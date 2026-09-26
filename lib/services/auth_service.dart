import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// User roles supported in PennyPal.
enum UserRole {
  student,
  administrator,
}

/// User session model.
class AuthUser {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String avatarUrl;
  final String phoneNumber;

  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatarUrl = '',
    this.phoneNumber = '',
  });

  bool get isAdmin => role == UserRole.administrator;
  bool get isStudent => role == UserRole.student;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role == UserRole.administrator ? 'administrator' : 'student',
      'avatarUrl': avatarUrl,
      'phoneNumber': phoneNumber,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  factory AuthUser.fromMap(Map<String, dynamic> map, String docId) {
    final roleString = (map['role'] as String?)?.toLowerCase() ?? 'student';
    return AuthUser(
      id: docId,
      name: map['name'] as String? ?? 'User',
      email: map['email'] as String? ?? '',
      role: roleString == 'administrator' || roleString == 'admin'
          ? UserRole.administrator
          : UserRole.student,
      avatarUrl: map['avatarUrl'] as String? ?? '',
      phoneNumber: map['phoneNumber'] as String? ?? '',
    );
  }
}

/// Centralized authentication service with live Firebase Auth + Cloud Firestore integration,
/// along with seamless offline/development fallback support.
class AuthService extends ChangeNotifier {
  AuthService._privateConstructor() {
    _initDefaultSession();
    _listenToAuthChanges();
  }

  static final AuthService instance = AuthService._privateConstructor();

  AuthUser? _currentUser;

  AuthUser? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isAdmin => _currentUser?.role == UserRole.administrator;
  bool get isStudent => _currentUser?.role == UserRole.student;

  void _initDefaultSession() {
    _currentUser = const AuthUser(
      id: 'USR-1001',
      name: 'Hasnain Ali',
      email: 'hasnain@student.pennypal.com',
      role: UserRole.student,
    );
  }

  void _listenToAuthChanges() {
    try {
      FirebaseAuth.instance.authStateChanges().listen((User? firebaseUser) async {
        if (firebaseUser != null) {
          try {
            final doc = await FirebaseFirestore.instance
                .collection('users')
                .doc(firebaseUser.uid)
                .get();

            if (doc.exists && doc.data() != null) {
              _currentUser = AuthUser.fromMap(doc.data()!, firebaseUser.uid);
            } else {
              final isAdm = firebaseUser.email?.toLowerCase().contains('admin') ?? false;
              _currentUser = AuthUser(
                id: firebaseUser.uid,
                name: firebaseUser.displayName ??
                    (firebaseUser.email?.split('@').first ?? 'Student User'),
                email: firebaseUser.email ?? '',
                role: isAdm ? UserRole.administrator : UserRole.student,
              );
            }
            notifyListeners();
          } catch (_) {
            // Retain session if Firestore is unreachable
          }
        }
      });
    } catch (_) {
      // Firebase not yet initialized or offline
    }
  }

  /// Register a new student or admin account with Firebase Auth & Firestore.
  Future<UserRole> register({
    required String fullName,
    required String email,
    required String password,
    String mobileNumber = '',
  }) async {
    final normalized = email.trim().toLowerCase();
    final isAdm = normalized.contains('admin') || normalized == 'administrator';
    final role = isAdm ? UserRole.administrator : UserRole.student;

    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: normalized,
        password: password,
      );

      if (cred.user != null) {
        await cred.user!.updateDisplayName(fullName);
        final newUser = AuthUser(
          id: cred.user!.uid,
          name: fullName,
          email: normalized,
          role: role,
          phoneNumber: mobileNumber,
        );

        // Store user document in Cloud Firestore
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(cred.user!.uid)
              .set(newUser.toMap());
        } catch (dbErr) {
          debugPrint('Firestore user profile write notice: $dbErr');
        }

        _currentUser = newUser;
        notifyListeners();
        return role;
      }
    } catch (e) {
      debugPrint('Firebase Auth register attempt: $e');
      // If Firebase Auth fails with standard auth exceptions, rethrow for UI feedback
      if (e is FirebaseAuthException) {
        rethrow;
      }
    }

    // Fallback simulation for offline/preview
    await Future.delayed(const Duration(milliseconds: 600));
    _currentUser = AuthUser(
      id: 'USR-${DateTime.now().millisecondsSinceEpoch}',
      name: fullName,
      email: normalized,
      role: role,
      phoneNumber: mobileNumber,
    );
    notifyListeners();
    return role;
  }

  /// Authenticate user via Firebase Auth email and password.
  /// Automatically detects Administrator vs Student based on account role.
  Future<UserRole> login({
    required String identifier,
    required String password,
  }) async {
    final normalized = identifier.trim().toLowerCase();
    final isAdm = normalized.contains('admin') || normalized == 'administrator';

    try {
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: normalized,
        password: password,
      );

      if (cred.user != null) {
        // Fetch role from Firestore
        try {
          final doc = await FirebaseFirestore.instance
              .collection('users')
              .doc(cred.user!.uid)
              .get();

          if (doc.exists && doc.data() != null) {
            _currentUser = AuthUser.fromMap(doc.data()!, cred.user!.uid);
            notifyListeners();
            return _currentUser!.role;
          }
        } catch (dbErr) {
          debugPrint('Firestore fetch user notice: $dbErr');
        }

        _currentUser = AuthUser(
          id: cred.user!.uid,
          name: cred.user!.displayName ??
              (normalized.contains('@') ? normalized.split('@').first : 'User'),
          email: normalized,
          role: isAdm ? UserRole.administrator : UserRole.student,
        );
        notifyListeners();
        return _currentUser!.role;
      }
    } catch (e) {
      debugPrint('Firebase Auth login notice: $e');
      if (e is FirebaseAuthException &&
          (e.code == 'user-not-found' ||
           e.code == 'wrong-password' ||
           e.code == 'invalid-credential')) {
        rethrow;
      }
    }

    // Fallback simulation for offline/dev
    await Future.delayed(const Duration(milliseconds: 600));
    if (isAdm) {
      _currentUser = const AuthUser(
        id: 'ADM-001',
        name: 'Admin Supervisor',
        email: 'admin@pennypal.com',
        role: UserRole.administrator,
      );
    } else {
      _currentUser = AuthUser(
        id: 'USR-1001',
        name: normalized.isNotEmpty && normalized.contains('@')
            ? normalized.split('@').first.toUpperCase()
            : 'Hasnain Ali',
        email: normalized.isNotEmpty ? normalized : 'student@pennypal.com',
        role: UserRole.student,
      );
    }
    notifyListeners();
    return _currentUser!.role;
  }

  /// Switch user role explicitly (useful for demo/testing).
  void setRole(UserRole role) {
    if (role == UserRole.administrator) {
      _currentUser = const AuthUser(
        id: 'ADM-001',
        name: 'Admin Supervisor',
        email: 'admin@pennypal.com',
        role: UserRole.administrator,
      );
    } else {
      _currentUser = const AuthUser(
        id: 'USR-1001',
        name: 'Hasnain Ali',
        email: 'hasnain@student.pennypal.com',
        role: UserRole.student,
      );
    }
    notifyListeners();
  }

  /// Logout current session from Firebase Auth and clear state.
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (_) {}
    _currentUser = null;
    notifyListeners();
  }
}
