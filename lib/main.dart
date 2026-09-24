import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/feedback_screen.dart';
import 'screens/contact_support_screen.dart';

void main() {
  runApp(const PennyPalApp());
}

class PennyPalApp extends StatelessWidget {
  const PennyPalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PennyPal',

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
        ),
      ),

      initialRoute: '/',

      routes: {
        '/': (context) => const HomeScreen(),
        '/feedback': (context) => const FeedbackScreen(),
        '/contact-support': (context) => const ContactSupportScreen(),
      },
    );
  }
}