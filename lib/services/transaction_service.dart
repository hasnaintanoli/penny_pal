import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Model representing an individual transaction record in PennyPal.
class TransactionItem {
  final String id;
  final String category;
  final String description;
  final String dateOrTime;
  final double amount;
  final bool isIncome;
  final String transactionType; // 'income', 'expense', 'transfer'
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String? receiptPath;
  final String? receiptName;
  final DateTime? dateTime;

  const TransactionItem({
    required this.id,
    required this.category,
    required this.description,
    required this.dateOrTime,
    required this.amount,
    required this.isIncome,
    this.transactionType = 'expense',
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    this.receiptPath,
    this.receiptName,
    this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'description': description,
      'dateOrTime': dateOrTime,
      'amount': amount,
      'isIncome': isIncome,
      'transactionType': transactionType,
      'receiptName': receiptName,
      'timestamp': dateTime != null
          ? Timestamp.fromDate(dateTime!)
          : FieldValue.serverTimestamp(),
    };
  }

  factory TransactionItem.fromMap(Map<String, dynamic> map, String docId) {
    final isInc = map['isIncome'] as bool? ?? false;
    final cat = map['category'] as String? ?? 'General';
    final amount = (map['amount'] as num?)?.toDouble() ?? 0.0;

    return TransactionItem(
      id: docId,
      category: cat,
      description: map['description'] as String? ?? 'Transaction',
      dateOrTime: map['dateOrTime'] as String? ?? 'Today',
      amount: amount,
      isIncome: isInc,
      transactionType:
          map['transactionType'] as String? ?? (isInc ? 'income' : 'expense'),
      icon: isInc ? Icons.arrow_downward_rounded : Icons.shopping_bag_rounded,
      iconColor: isInc ? const Color(0xFF10B981) : const Color(0xFFEF4444),
      iconBgColor: isInc ? const Color(0xFFE8F8F2) : const Color(0xFFFEECEC),
      receiptName: map['receiptName'] as String?,
      dateTime: (map['timestamp'] is Timestamp)
          ? (map['timestamp'] as Timestamp).toDate()
          : null,
    );
  }
}

/// Centralized state management service for PennyPal transactions.
/// Provides live reactive updates across HomeScreen, TransactionsScreen, and AddTransactionScreen,
/// synchronized with Cloud Firestore.
class TransactionService extends ChangeNotifier {
  static final TransactionService instance = TransactionService._internal();

  TransactionService._internal() {
    _initDefaultTransactions();
  }

  final List<TransactionItem> _transactions = [];

  List<TransactionItem> get transactions => List.unmodifiable(_transactions);

  void _initDefaultTransactions() {
    _transactions.addAll([
      const TransactionItem(
        id: 'TXN-001',
        category: 'Food & Dining',
        description: "McDonald's",
        dateOrTime: '10:24 AM',
        amount: 450,
        isIncome: false,
        transactionType: 'expense',
        icon: Icons.restaurant_rounded,
        iconColor: Color(0xFFEF4444),
        iconBgColor: Color(0xFFFEECEC),
      ),
      const TransactionItem(
        id: 'TXN-002',
        category: 'Freelance Work',
        description: 'Upwork Payment',
        dateOrTime: '09:15 AM',
        amount: 8000,
        isIncome: true,
        transactionType: 'income',
        icon: Icons.work_rounded,
        iconColor: Color(0xFF10B981),
        iconBgColor: Color(0xFFE8F8F2),
      ),
      const TransactionItem(
        id: 'TXN-003',
        category: 'Transport',
        description: 'Bus Fare',
        dateOrTime: '08:42 AM',
        amount: 200,
        isIncome: false,
        transactionType: 'expense',
        icon: Icons.directions_bus_rounded,
        iconColor: Color(0xFF8B5CF6),
        iconBgColor: Color(0xFFF3E8FF),
      ),
      const TransactionItem(
        id: 'TXN-004',
        category: 'Shopping',
        description: 'Daraz',
        dateOrTime: '06:30 PM',
        amount: 1250,
        isIncome: false,
        transactionType: 'expense',
        icon: Icons.shopping_bag_rounded,
        iconColor: Color(0xFF0077F6),
        iconBgColor: Color(0xFFEBF3FE),
      ),
      const TransactionItem(
        id: 'TXN-005',
        category: 'Salary',
        description: 'HBL Bank',
        dateOrTime: 'May 13, 2025',
        amount: 10000,
        isIncome: true,
        transactionType: 'income',
        icon: Icons.account_balance_wallet_rounded,
        iconColor: Color(0xFF10B981),
        iconBgColor: Color(0xFFE8F8F2),
      ),
      const TransactionItem(
        id: 'TXN-006',
        category: 'Bills & Utilities',
        description: 'Electricity Bill',
        dateOrTime: 'May 12, 2025',
        amount: 2450,
        isIncome: false,
        transactionType: 'expense',
        icon: Icons.receipt_long_rounded,
        iconColor: Color(0xFFF59E0B),
        iconBgColor: Color(0xFFFEF3C7),
      ),
      const TransactionItem(
        id: 'TXN-007',
        category: 'Education',
        description: 'Book Purchase',
        dateOrTime: 'May 12, 2025',
        amount: 1200,
        isIncome: false,
        transactionType: 'expense',
        icon: Icons.school_rounded,
        iconColor: Color(0xFF8B5CF6),
        iconBgColor: Color(0xFFF3E8FF),
      ),
    ]);
  }

  /// Syncs transactions for a specific user from Firestore.
  void syncWithFirestore(String userId) {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .listen((snapshot) {
            if (snapshot.docs.isNotEmpty) {
              final items = snapshot.docs
                  .map((doc) => TransactionItem.fromMap(doc.data(), doc.id))
                  .toList();
              _transactions.clear();
              _transactions.addAll(items);
              notifyListeners();
            }
          });
    } catch (_) {}
  }

  /// Adds a new transaction at the beginning of the list and stores in Firestore.
  void addTransaction(TransactionItem item, {String? userId}) {
    _transactions.insert(0, item);
    notifyListeners();

    // Firestore async sync
    try {
      if (userId != null && userId.isNotEmpty) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('transactions')
            .doc(item.id)
            .set(item.toMap())
            .catchError(
              (e) => debugPrint('Firestore add transaction error: $e'),
            );
      }
    } catch (_) {}
  }

  /// Deletes a transaction by id and removes from Firestore.
  void deleteTransaction(String id, {String? userId}) {
    _transactions.removeWhere((item) => item.id == id);
    notifyListeners();

    try {
      if (userId != null && userId.isNotEmpty) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('transactions')
            .doc(id)
            .delete()
            .catchError(
              (e) => debugPrint('Firestore delete transaction error: $e'),
            );
      }
    } catch (_) {}
  }

  /// Calculates dynamic total income from all income transactions.
  double get totalIncome {
    return _transactions
        .where((t) => t.isIncome)
        .fold(0.0, (acc, t) => acc + t.amount);
  }

  /// Calculates dynamic total expenses from all expense transactions.
  double get totalExpenses {
    return _transactions
        .where((t) => !t.isIncome)
        .fold(0.0, (acc, t) => acc + t.amount);
  }

  /// Calculates net balance.
  double get totalBalance {
    return totalIncome - totalExpenses;
  }
}
