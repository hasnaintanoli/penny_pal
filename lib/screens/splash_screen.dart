import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../widgets/loading_bar.dart';

/// A modern, minimal, and fully responsive splash/loading screen for PennyPal.
///
/// Features the official PennyPal background, centered brand logo,
/// and smooth pill-shaped loading indicator matching the design reference.
class SplashScreen extends StatefulWidget {
  /// Whether to display the animated pill loading bar below the logo.
  final bool showLoadingBar;

  /// Optional fixed progress (0.0 to 1.0) for the loading bar.
  /// If null, a smooth indeterminate animation is played.
  final double? loadingProgress;

  /// Optional duration before [onInitialized] is triggered.
  final Duration? autoNavigateDuration;

  /// Optional callback triggered when initialization / loading completes.
  final VoidCallback? onInitialized;

  const SplashScreen({
    super.key,
    this.showLoadingBar = true,
    this.loadingProgress,
    this.autoNavigateDuration,
    this.onInitialized,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    // Subtle, high-polish entrance animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    _scaleAnimation = Tween<double>(begin: 0.94, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();

    // Handle optional automatic navigation callback with cancelable Timer
    if (widget.autoNavigateDuration != null && widget.onInitialized != null) {
      _navigationTimer = Timer(widget.autoNavigateDuration!, () {
        if (mounted) {
          widget.onInitialized!();
        }
      });
    }
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

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
        backgroundColor: AppColors.splashCanvas,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Full-screen responsive background image
            _buildBackgroundImage(),

            // 2. Centered responsive logo and loading bar
            _buildCenteredContent(),
          ],
        ),
      ),
    );
  }

  /// Renders the supplied background asset with optimal coverage and aspect-ratio preservation.
  Widget _buildBackgroundImage() {
    return Positioned.fill(
      child: Image.asset(
        AppAssets.splashBackground,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        filterQuality: FilterQuality.high,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE8F2FC),
                  Color(0xFFFFFFFF),
                  Color(0xFFD6EAFE),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Calculates responsive dimensions for the PennyPal logo and loading bar.
  Widget _buildCenteredContent() {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double maxWidth = constraints.maxWidth;
          final double maxHeight = constraints.maxHeight;

          final double shortestSide = maxWidth < maxHeight
              ? maxWidth
              : maxHeight;

          // Responsive logo sizing
          final double targetLogoSize = (shortestSide * 0.56).clamp(
            160.0,
            320.0,
          );
          final double responsiveLogoSize = targetLogoSize > maxHeight * 0.40
              ? maxHeight * 0.40
              : targetLogoSize;

          // Responsive loading bar sizing
          final double barWidth = (responsiveLogoSize * 0.34).clamp(58.0, 88.0);
          final double barHeight = (shortestSide < 360) ? 5.5 : 7.0;
          final double spacing = (maxHeight * 0.02).clamp(12.0, 24.0);

          return Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Brand Logo
                    SizedBox(
                      width: responsiveLogoSize,
                      height: responsiveLogoSize,
                      child: Image.asset(
                        AppAssets.pennyPalLogo,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.account_balance_wallet_rounded,
                              size: 72,
                              color: AppColors.primaryBlue,
                            ),
                          );
                        },
                      ),
                    ),

                    // Pill Loading Bar
                    if (widget.showLoadingBar) ...[
                      SizedBox(height: spacing),
                      PennyPalLoadingBar(
                        width: barWidth,
                        height: barHeight,
                        progress: widget.loadingProgress,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
