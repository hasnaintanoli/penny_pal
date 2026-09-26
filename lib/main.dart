import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants/app_colors.dart';
import 'screens/login_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/register_screen.dart';
import 'screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      },
    );
  }
}
