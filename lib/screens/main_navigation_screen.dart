import 'package:flutter/material.dart';
import '../widgets/liquid_glass_bottom_nav_bar.dart';
import 'home_screen.dart';
import 'transactions_screen.dart';
import 'budget_screen.dart';
import 'goals_screen.dart';
import 'more_screen.dart';

/// Inherited scope to allow any descendant widget (drawers, buttons, banners)
/// to switch tabs smoothly within [MainNavigationScreen].
class MainNavigationScope extends InheritedWidget {
  final void Function(int index) switchTab;
  final int currentIndex;

  const MainNavigationScope({
    super.key,
    required this.switchTab,
    required this.currentIndex,
    required super.child,
  });

  static MainNavigationScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MainNavigationScope>();
  }

  @override
  bool updateShouldNotify(MainNavigationScope oldWidget) {
    return currentIndex != oldWidget.currentIndex;
  }
}

/// Main application shell that hosts all 5 primary tabs
/// (Home, Transactions, Budgets, Goals, More) with a persistent Liquid Glass Bottom Navigation Bar.
/// Ensures the liquid bubble sliding animation executes smoothly across all 5 tab switches.
class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;
  final String userName;

  const MainNavigationScreen({
    super.key,
    this.initialIndex = 0,
    this.userName = 'Hasnain',
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, 4);
  }

  void switchTab(int index) {
    if (index >= 0 && index < 5 && index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainNavigationScope(
      switchTab: switchTab,
      currentIndex: _currentIndex,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: Stack(
          children: [
            // 1. All 5 Screens hosted in IndexedStack to preserve state & prevent reloading
            IndexedStack(
              index: _currentIndex,
              children: [
                HomeScreen(
                  userName: widget.userName,
                  showBottomNav: false,
                ),
                const TransactionsScreen(showBottomNav: false),
                const BudgetScreen(showBottomNav: false),
                const GoalsScreen(showBottomNav: false),
                const MoreScreen(showBottomNav: false),
              ],
            ),

            // 2. Persistent Floating Liquid Glass Bottom Navigation Bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Center(
                child: LiquidGlassBottomNavBar(
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    if (index < 5) {
                      switchTab(index);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
