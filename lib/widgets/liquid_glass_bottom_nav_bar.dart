import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// Navigation item model for [LiquidGlassBottomNavBar].
class LiquidNavItem {
  final IconData icon;
  final String label;
  final String route;

  const LiquidNavItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}

/// Standard 5 items for PennyPal navigation
const List<LiquidNavItem> kPennyPalNavItems = [
  LiquidNavItem(icon: Icons.home_rounded, label: 'Home', route: '/home'),
  LiquidNavItem(
    icon: Icons.swap_horiz_rounded,
    label: 'Transactions',
    route: '/transactions',
  ),
  LiquidNavItem(
    icon: Icons.pie_chart_rounded,
    label: 'Budgets',
    route: '/budgets',
  ),
  LiquidNavItem(
    icon: Icons.track_changes_rounded,
    label: 'Goals',
    route: '/goals',
  ),
  LiquidNavItem(icon: Icons.grid_view_rounded, label: 'More', route: '/more'),
];

/// A premium, modern iOS-inspired Liquid Glass Bottom Navigation Bar for PennyPal.
/// Features frosted backdrop glassmorphism, 3D liquid refraction droplets,
/// specular rim lighting, subtle blue-cyan edge glow, and a smooth animated active bubble.
class LiquidGlassBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final List<LiquidNavItem> items;

  const LiquidGlassBottomNavBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.items = kPennyPalNavItems,
  });

  @override
  State<LiquidGlassBottomNavBar> createState() =>
      _LiquidGlassBottomNavBarState();
}

class _LiquidGlassBottomNavBarState extends State<LiquidGlassBottomNavBar> {
  int? _pressedIndex;

  void _handleTap(int index) {
    if (widget.onTap != null) {
      widget.onTap!(index);
    } else {
      if (index == widget.currentIndex) return;
      final target = widget.items[index];
      if (target.route == '/more') {
        _showMoreOptionsBottomSheet(context);
      } else {
        Navigator.of(context).pushReplacementNamed(target.route);
      }
    }
  }

  void _showMoreOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'More PennyPal Tools',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Access settings, export statements, and student financial tips.',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              _buildMoreActionTile(
                ctx,
                icon: Icons.receipt_long_rounded,
                title: 'Export Statements (PDF / CSV)',
                color: AppColors.primaryBlue,
              ),
              _buildMoreActionTile(
                ctx,
                icon: Icons.notifications_active_rounded,
                title: 'Notification Preferences',
                color: const Color(0xFF10B981),
              ),
              _buildMoreActionTile(
                ctx,
                icon: Icons.security_rounded,
                title: 'Security & PIN Lock',
                color: const Color(0xFF8B5CF6),
              ),
              _buildMoreActionTile(
                ctx,
                icon: Icons.help_outline_rounded,
                title: 'Help & Support Center',
                color: const Color(0xFFF59E0B),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Close',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMoreActionTile(
    BuildContext ctx, {
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: ListTile(
        dense: true,
        leading: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Color(0xFF94A3B8),
          size: 18,
        ),
        onTap: () {
          Navigator.pop(ctx);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '$title selected',
                style: GoogleFonts.poppins(fontSize: 12.5),
              ),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.only(
        left: 14,
        right: 14,
        top: 6,
        bottom: bottomPadding > 0 ? bottomPadding + 4 : 12,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(36),
            // Outer Liquid Glass Shadows & Cyan-Blue Refractive Glow
            boxShadow: [
              // Deep ambient base shadow
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.08),
                blurRadius: 26,
                spreadRadius: 0,
                offset: const Offset(0, 10),
              ),
              // Soft cyan-blue glass ambient glow
              BoxShadow(
                color: const Color(0xFF38BDF8).withValues(alpha: 0.18),
                blurRadius: 20,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
              // White rim reflection back-glow
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.70),
                blurRadius: 8,
                spreadRadius: -2,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(36),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: CustomPaint(
                painter: _LiquidGlassPainter(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(36),
                    // Multi-stop glass gradient
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: 0.82),
                        const Color(0xFFF1F6FE).withValues(alpha: 0.60),
                        const Color(0xFFE2EFFF).withValues(alpha: 0.68),
                      ],
                      stops: const [0.0, 0.45, 1.0],
                    ),
                    // Translucent white outer glass border
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.88),
                      width: 1.5,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Specular top highlight line (curved light refraction on top rim)
                      Positioned(
                        top: 0,
                        left: 24,
                        right: 24,
                        height: 1.5,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0.0),
                                Colors.white.withValues(alpha: 0.95),
                                Colors.white.withValues(alpha: 0.0),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Navigation Items Row
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final count = widget.items.length;
                          final itemWidth = constraints.maxWidth / count;
                          final activeIndex = widget.currentIndex.clamp(
                            0,
                            count - 1,
                          );

                          return Stack(
                            children: [
                              // Sliding Active Liquid Glass Droplet Bubble
                              AnimatedPositioned(
                                duration: const Duration(milliseconds: 320),
                                curve: Curves.easeOutCubic,
                                left:
                                    activeIndex * itemWidth +
                                    (itemWidth - 52) / 2,
                                top: 5,
                                child: Container(
                                  width: 52,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(19),
                                    // Liquid Droplet 3D Glass Surface
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.white.withValues(alpha: 0.90),
                                        const Color(
                                          0xFFDBEAFE,
                                        ).withValues(alpha: 0.45),
                                        const Color(
                                          0xFFBFDBFE,
                                        ).withValues(alpha: 0.65),
                                      ],
                                    ),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.95,
                                      ),
                                      width: 1.2,
                                    ),
                                    boxShadow: [
                                      // Top-left specular bubble shine
                                      BoxShadow(
                                        color: Colors.white.withValues(
                                          alpha: 0.9,
                                        ),
                                        offset: const Offset(-1, -1),
                                        blurRadius: 3,
                                      ),
                                      // Blue liquid refraction shadow
                                      BoxShadow(
                                        color: const Color(
                                          0xFF2563EB,
                                        ).withValues(alpha: 0.16),
                                        offset: const Offset(0, 3),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      // Internal highlight specular spot
                                      Positioned(
                                        top: 3,
                                        left: 10,
                                        child: Container(
                                          width: 14,
                                          height: 3,
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(
                                              alpha: 0.85,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              2,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Items Row
                              Row(
                                children: List.generate(count, (index) {
                                  final item = widget.items[index];
                                  final isActive = index == activeIndex;
                                  final isPressed = _pressedIndex == index;

                                  return Expanded(
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTapDown: (_) {
                                        setState(() {
                                          _pressedIndex = index;
                                        });
                                      },
                                      onTapUp: (_) {
                                        setState(() {
                                          _pressedIndex = null;
                                        });
                                        _handleTap(index);
                                      },
                                      onTapCancel: () {
                                        setState(() {
                                          _pressedIndex = null;
                                        });
                                      },
                                      child: AnimatedScale(
                                        scale: isPressed
                                            ? 0.92
                                            : (isActive ? 1.04 : 1.0),
                                        duration: const Duration(
                                          milliseconds: 140,
                                        ),
                                        curve: Curves.easeOutQuad,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 6.0,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // Icon Area with Inactive Glass Droplet
                                              SizedBox(
                                                width: 44,
                                                height: 34,
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    // Faint inactive droplet water refraction behind inactive items
                                                    if (!isActive)
                                                      Container(
                                                        width: 38,
                                                        height: 28,
                                                        decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.white
                                                              .withValues(
                                                                alpha: 0.28,
                                                              ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color:
                                                                  const Color(
                                                                    0xFF64748B,
                                                                  ).withValues(
                                                                    alpha: 0.05,
                                                                  ),
                                                              offset:
                                                                  const Offset(
                                                                    0,
                                                                    1.5,
                                                                  ),
                                                              blurRadius: 3,
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                    // Main Icon
                                                    Icon(
                                                      item.icon,
                                                      size: isActive
                                                          ? 22.5
                                                          : 21,
                                                      color: isActive
                                                          ? AppColors
                                                                .primaryBlue
                                                          : const Color(
                                                              0xFF64748B,
                                                            ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 2),

                                              // Label
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: AnimatedDefaultTextStyle(
                                                  duration: const Duration(
                                                    milliseconds: 200,
                                                  ),
                                                  style: GoogleFonts.poppins(
                                                    fontSize: isActive
                                                        ? 10.8
                                                        : 10.2,
                                                    fontWeight: isActive
                                                        ? FontWeight.w600
                                                        : FontWeight.w500,
                                                    color: isActive
                                                        ? AppColors.primaryBlue
                                                        : const Color(
                                                            0xFF64748B,
                                                          ),
                                                    letterSpacing: -0.1,
                                                  ),
                                                  child: Text(item.label),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom painter that adds subtle optical glass refractions, corner light glints,
/// and smooth caustics to the Liquid Glass Bottom Navigation Bar.
class _LiquidGlassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(36));

    // 1. Subtle top-half inner refraction highlight
    final topHighlightPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.center,
        colors: [
          Colors.white.withValues(alpha: 0.35),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(rect);

    canvas.drawRRect(rrect, topHighlightPaint);

    // 2. Subtle bottom cyan caustic refraction
    final bottomCausticPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.bottomRight,
        radius: 1.2,
        colors: [
          const Color(0xFF60A5FA).withValues(alpha: 0.12),
          Colors.transparent,
        ],
      ).createShader(rect);

    canvas.drawRRect(rrect, bottomCausticPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
