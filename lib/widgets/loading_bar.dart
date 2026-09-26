import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// A modern, pill-shaped loading bar matching the PennyPal visual identity.
///
/// Supports both smooth indeterminate animation and determinate progress (0.0 to 1.0).
class PennyPalLoadingBar extends StatefulWidget {
  /// Width of the loading bar. Defaults to responsive 72 logical pixels.
  final double width;

  /// Height / thickness of the bar. Defaults to 7.0 logical pixels.
  final double height;

  /// Optional fixed progress value between 0.0 and 1.0.
  /// If null, the bar runs a smooth indeterminate sliding animation.
  final double? progress;

  /// Background track color. Defaults to soft translucent sky blue.
  final Color trackColor;

  /// Active indicator color. Defaults to PennyPal primary blue.
  final Color indicatorColor;

  /// Duration for one complete sweep cycle.
  final Duration cycleDuration;

  const PennyPalLoadingBar({
    super.key,
    this.width = 76.0,
    this.height = 7.0,
    this.progress,
    this.trackColor = const Color(0xFFD6E8FC),
    this.indicatorColor = AppColors.primaryBlue,
    this.cycleDuration = const Duration(milliseconds: 1400),
  });

  @override
  State<PennyPalLoadingBar> createState() => _PennyPalLoadingBarState();
}

class _PennyPalLoadingBarState extends State<PennyPalLoadingBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.cycleDuration,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    if (widget.progress == null) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant PennyPalLoadingBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.progress != null && _controller.isAnimating) {
      _controller.stop();
    } else if (widget.progress == null && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double radius = widget.height / 2;

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.trackColor,
        borderRadius: BorderRadius.circular(radius),
      ),
      clipBehavior: Clip.antiAlias,
      child: widget.progress != null
          ? _buildDeterminate(radius)
          : _buildIndeterminate(radius),
    );
  }

  Widget _buildDeterminate(double radius) {
    final clampedProgress = widget.progress!.clamp(0.0, 1.0);
    return Align(
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: clampedProgress,
        heightFactor: 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: widget.indicatorColor,
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      ),
    );
  }

  Widget _buildIndeterminate(double radius) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // Active indicator width factor (~55% of track width)
        const double indicatorFactor = 0.55;
        // Slide alignment from left (-1.0) to right (1.0)
        final double alignX = -1.0 + (_animation.value * 2.0);

        return Align(
          alignment: Alignment(alignX, 0.0),
          child: FractionallySizedBox(
            widthFactor: indicatorFactor,
            heightFactor: 1.0,
            child: Container(
              decoration: BoxDecoration(
                color: widget.indicatorColor,
                borderRadius: BorderRadius.circular(radius),
              ),
            ),
          ),
        );
      },
    );
  }
}
