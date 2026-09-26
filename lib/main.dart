import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'admin/admin_layout.dart';
import 'constants/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/about_screen.dart';
import 'screens/add_transaction_screen.dart';
import 'screens/ai_assistant_screen.dart';
import 'screens/contact_support_screen.dart';
import 'screens/create_goal_screen.dart';
import 'screens/feedback_screen.dart';
import 'screens/learning_screen.dart';
import 'screens/login_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/register_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization status: $e');
  }
  runApp(const PennyPalApp());
}

/// Root widget for PennyPal Student Personal Finance Application.
class PennyPalApp extends StatelessWidget {
  const PennyPalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PennyPal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryBlue,
          primary: AppColors.primaryBlue,
          secondary: AppColors.accentGreen,
          surface: AppColors.backgroundLight,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.backgroundLight,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(
          autoNavigateDuration: const Duration(milliseconds: 2400),
          onInitialized: () {
            Navigator.of(context).pushReplacementNamed('/onboarding');
          },
        ),
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/main': (context) => const MainNavigationScreen(),
        '/home': (context) => const MainNavigationScreen(initialIndex: 0),
        '/transactions': (context) =>
            const MainNavigationScreen(initialIndex: 1),
        '/budgets': (context) => const MainNavigationScreen(initialIndex: 2),
        '/budget': (context) => const MainNavigationScreen(initialIndex: 2),
        '/goals': (context) => const MainNavigationScreen(initialIndex: 3),
        '/goal': (context) => const MainNavigationScreen(initialIndex: 3),
        '/more': (context) => const MainNavigationScreen(initialIndex: 4),
        '/add-transaction': (context) => const AddTransactionScreen(),
        '/create-goal': (context) => const CreateGoalScreen(),
        '/learning': (context) => const LearningScreen(),
        '/ai-assistant': (context) => const AIAssistantScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/reports': (context) => const ReportsScreen(),
        '/feedback': (context) => const FeedbackScreen(),
        '/contact-support': (context) => const ContactSupportScreen(),
        '/about': (context) => const AboutScreen(),
        // Admin Portal Routes
        '/admin': (context) => const AdminLayoutScreen(),
        '/admin/dashboard': (context) => const AdminLayoutScreen(initialNavIndex: 0),
        '/admin/students': (context) => const AdminLayoutScreen(initialNavIndex: 1),
        '/admin/activity': (context) => const AdminLayoutScreen(initialNavIndex: 2),
        '/admin/analytics': (context) => const AdminLayoutScreen(initialNavIndex: 3),
        '/admin/learning': (context) => const AdminLayoutScreen(initialNavIndex: 4),
        '/admin/support': (context) => const AdminLayoutScreen(initialNavIndex: 5),
        '/admin/feedback': (context) => const AdminLayoutScreen(initialNavIndex: 6),
        '/admin/notifications': (context) => const AdminLayoutScreen(initialNavIndex: 7),
        '/admin/categories': (context) => const AdminLayoutScreen(initialNavIndex: 8),
        '/admin/settings': (context) => const AdminLayoutScreen(initialNavIndex: 9),
        '/admin/profile': (context) => const AdminLayoutScreen(initialNavIndex: 10),
      },
    );
  }
}
