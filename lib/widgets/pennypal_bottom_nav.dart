import 'package:flutter/material.dart';

class PennyPalBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const PennyPalBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2563EB).withOpacity(0.10),
              blurRadius: 25,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(
              index: 0,
              icon: Icons.home_rounded,
              label: 'Home',
            ),
            _navItem(
              index: 1,
              icon: Icons.swap_horiz_rounded,
              label: 'Transactions',
            ),
            _navItem(
              index: 2,
              icon: Icons.pie_chart_rounded,
              label: 'Budgets',
            ),
            _navItem(
              index: 3,
              icon: Icons.track_changes_rounded,
              label: 'Goals',
            ),
            _navItem(
              index: 4,
              icon: Icons.menu_rounded,
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool selected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 27,
              color: selected
                  ? const Color(0xFF2563EB)
                  : const Color(0xFF7692B5),
            ),

            const SizedBox(height: 3),

            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight:
                selected ? FontWeight.w600 : FontWeight.w500,
                color: selected
                    ? const Color(0xFF2563EB)
                    : const Color(0xFF7692B5),
              ),
            ),

            const SizedBox(height: 4),

            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 3,
              width: selected ? 32 : 0,
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}