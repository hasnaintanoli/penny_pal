import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../widgets/feature_item.dart';

/// The official PennyPal Get Started / Onboarding Screen.
///
/// Designed with Material 3 principles for students and young people,
/// providing a modern, friendly, clean, and responsive introduction
/// to personal finance management.
class OnboardingScreen extends StatelessWidget {
  /// Callback triggered when the user taps "Get Started".
  final VoidCallback? onGetStarted;

  /// Callback triggered when the user taps "Login".
  final VoidCallback? onLogin;

  /// Callback triggered when the user taps "Skip".
  final VoidCallback? onSkip;

  const OnboardingScreen({
    super.key,
    this.onGetStarted,
    this.onLogin,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double screenWidth = constraints.maxWidth;
              final double screenHeight = constraints.maxHeight;
              final double shortestSide = screenWidth < screenHeight
                  ? screenWidth
                  : screenHeight;

              // Responsive dimensions
              final double horizontalPadding = (screenWidth * 0.06).clamp(
                18.0,
                32.0,
              );
              final double illustrationHeight = (screenHeight * 0.25).clamp(
                150.0,
                230.0,
              );
              final double headingFontSize = (shortestSide * 0.062).clamp(
                21.0,
                26.0,
              );
              final double descriptionFontSize = (shortestSide * 0.035).clamp(
                13.0,
                14.5,
              );

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 12.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 1. Top Section: Skip Button
                        _buildHeader(context),
                        const SizedBox(height: 6),

                        // 2. Illustration Section
                        _buildIllustration(illustrationHeight),
                        const SizedBox(height: 18),

                        // 3. Welcome Content (Heading + Description)
                        _buildWelcomeContent(
                          headingFontSize: headingFontSize,
                          descriptionFontSize: descriptionFontSize,
                        ),
                        const SizedBox(height: 20),

                        // 4. Feature Highlights List (3 Items)
                        _buildFeatureList(),
                        const SizedBox(height: 26),

                        // 5. Primary CTA Button ("Get Started")
                        _buildGetStartedButton(context),
                        const SizedBox(height: 14),

                        // 6. Login Footer Link
                        _buildLoginFooter(context),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// Top header with right-aligned "Skip" action.
  Widget _buildHeader(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed:
            onSkip ??
            () {
              Navigator.of(context).pushNamed('/login');
            },
        style: TextButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          'Skip',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  /// Official PennyPal onboarding illustration.
  Widget _buildIllustration(double height) {
    return Center(
      child: SizedBox(
        height: height,
        child: Image.asset(
          AppAssets.onboardingIllustration,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Icon(
                Icons.savings_rounded,
                size: height * 0.5,
                color: AppColors.primaryBlue,
              ),
            );
          },
        ),
      ),
    );
  }

  /// Welcome heading and supporting description text.
  Widget _buildWelcomeContent({
    required double headingFontSize,
    required double descriptionFontSize,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Better Money Habits\nfor a Brighter Future',
          style: GoogleFonts.poppins(
            fontSize: headingFontSize,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            height: 1.22,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Track your expenses, set budgets,\nsave for your goals and learn\nsmart money habits — all in one place.',
          style: GoogleFonts.poppins(
            fontSize: descriptionFontSize,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            height: 1.45,
          ),
        ),
      ],
    );
  }

  /// Feature highlights list displaying 3 core capabilities.
  Widget _buildFeatureList() {
    return const Column(
      children: [
        FeatureItem(
          icon: Icons.receipt_long_rounded,
          title: 'Track Expenses',
          description: 'Know where your money goes',
        ),
        SizedBox(height: 12),
        FeatureItem(
          icon: Icons.pie_chart_outline_rounded,
          title: 'Set Budgets',
          description: 'Stay in control',
        ),
        SizedBox(height: 12),
        FeatureItem(
          icon: Icons.savings_outlined,
          title: 'Save for Goals',
          description: 'Build your dreams',
        ),
      ],
    );
  }

  /// Primary "Get Started" CTA button.
  Widget _buildGetStartedButton(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.32),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed:
            onGetStarted ??
            () {
              Navigator.of(context).pushNamed('/register');
            },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(
          'Get Started',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }

  /// Bottom login link footer using RichText to guarantee zero flex overflow.
  Widget _buildLoginFooter(BuildContext context) {
    return Center(
      child: Text.rich(
        TextSpan(
          text: 'Already have an account? ',
          style: GoogleFonts.poppins(
            fontSize: 13.5,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
          children: [
            TextSpan(
              text: 'Login',
              style: GoogleFonts.poppins(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryBlue,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap =
                    onLogin ??
                    () {
                      Navigator.of(context).pushNamed('/login');
                    },
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
