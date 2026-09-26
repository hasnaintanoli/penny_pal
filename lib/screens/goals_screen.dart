import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../widgets/liquid_glass_bottom_nav_bar.dart';

/// Model representing a savings goal in PennyPal.
class GoalItem {
  final String id;
  final String title;
  final String category;
  final double savedAmount;
  final double targetAmount;
  final String targetDate;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final Color progressColor;
  final bool isAchieved;

  const GoalItem({
    required this.id,
    required this.title,
    required this.category,
    required this.savedAmount,
    required this.targetAmount,
    required this.targetDate,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.progressColor,
    this.isAchieved = false,
  });

  double get progress =>
      targetAmount > 0 ? (savedAmount / targetAmount).clamp(0.0, 1.0) : 0.0;
  int get percentage => (progress * 100).round();
  double get remainingAmount =>
      (targetAmount - savedAmount).clamp(0.0, double.infinity);
}

/// PennyPal Goals Screen for tracking savings goals, monitoring progress milestones,
/// managing target dates, and fostering motivating financial growth habits.
class GoalsScreen extends StatefulWidget {
  final bool showBottomNav;

  const GoalsScreen({super.key, this.showBottomNav = true});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final TextEditingController _searchController = TextEditingController();

  bool _isSearching = false;
  String _selectedMonth = 'May 2025';
  int _selectedNavIndex = 3; // Goals is active (index 3)

  final List<String> _availableMonths = [
    'May 2025',
    'April 2025',
    'March 2025',
    'February 2025',
    'January 2025',
  ];

  late List<GoalItem> _goals;

  @override
  void initState() {
    super.initState();
    _initGoalsData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _initGoalsData() {
    _goals = [
      const GoalItem(
        id: 'GOL-001',
        title: 'New Laptop',
        category: 'Tech & Equipment',
        savedAmount: 42000,
        targetAmount: 100000,
        targetDate: 'Dec 2025',
        icon: Icons.laptop_mac_rounded,
        iconBgColor: Color(0xFFEBF3FE),
        iconColor: Color(0xFF0077F6),
        progressColor: Color(0xFF0077F6),
      ),
      const GoalItem(
        id: 'GOL-002',
        title: 'Trip to Dubai',
        category: 'Travel',
        savedAmount: 15000,
        targetAmount: 80000,
        targetDate: 'Jun 2026',
        icon: Icons.flight_takeoff_rounded,
        iconBgColor: Color(0xFFE8FAF3),
        iconColor: Color(0xFF10B981),
        progressColor: Color(0xFF10B981),
      ),
      const GoalItem(
        id: 'GOL-003',
        title: 'Education (DAE)',
        category: 'Education',
        savedAmount: 8000,
        targetAmount: 60000,
        targetDate: 'Aug 2028',
        icon: Icons.school_rounded,
        iconBgColor: Color(0xFFF3E8FF),
        iconColor: Color(0xFF8B5CF6),
        progressColor: Color(0xFF8B5CF6),
      ),
      const GoalItem(
        id: 'GOL-004',
        title: 'Car Fund',
        category: 'Vehicle',
        savedAmount: 5000,
        targetAmount: 50000,
        targetDate: 'Dec 2027',
        icon: Icons.directions_car_rounded,
        iconBgColor: Color(0xFFFEF3C7),
        iconColor: Color(0xFFF59E0B),
        progressColor: Color(0xFFF59E0B),
      ),
    ];
  }

  int get _activeGoalsCount => _goals.where((g) => !g.isAchieved).length;

  double get _totalSavedAmount =>
      _goals.fold(0.0, (sum, item) => sum + item.savedAmount);

  double get _totalTargetAmount =>
      _goals.fold(0.0, (sum, item) => sum + item.targetAmount);

  double get _overallProgress => _totalTargetAmount > 0
      ? (_totalSavedAmount / _totalTargetAmount).clamp(0.0, 1.0)
      : 0.0;

  int get _overallPercentage => (_overallProgress * 100).round();

  List<GoalItem> get _filteredGoals {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return _goals;
    return _goals.where((g) {
      return g.title.toLowerCase().contains(query) ||
          g.category.toLowerCase().contains(query) ||
          g.targetDate.toLowerCase().contains(query) ||
          g.savedAmount.toString().contains(query) ||
          g.targetAmount.toString().contains(query);
    }).toList();
  }

  String _formatCurrency(num amount) {
    final intVal = amount.toInt();
    final str = intVal.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write(',');
      }
    }
    return buffer.toString().split('').reversed.join('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      floatingActionButton: _buildFloatingAddGoalButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              children: [
                // 1. Top Navigation Header
                _buildTopNavigationHeader(),

                // In-line Search Bar (When active)
                if (_isSearching) _buildInlineSearchBar(),

                // 2. Scrollable Body
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 6.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 3. Screen Title & Hero Spacing
                        _buildScreenTitleSection(),
                        const SizedBox(height: 65),

                        // 4. Total Goals Summary Card
                        _buildTotalGoalsSummaryCard(),
                        const SizedBox(height: 18),

                        // 5. Quick Action Buttons Grid (4 Actions)
                        _buildQuickActionsGrid(),
                        const SizedBox(height: 22),

                        // 6. Your Goals Section Header
                        _buildYourGoalsHeader(),
                        const SizedBox(height: 12),

                        // 7. Goals List Cards
                        _buildGoalsList(),
                        const SizedBox(height: 18),

                        // 8. Motivational Banner
                        _buildMotivationalBanner(),
                        SizedBox(
                          height: widget.showBottomNav ? 70 : 100,
                        ), // Spacing for floating button & bottom nav
                      ],
                    ),
                  ),
                ),

                // 9. Bottom Navigation Bar
                if (widget.showBottomNav) _buildBottomNavigationBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 1. TOP NAVIGATION HEADER
  // ==========================================
  Widget _buildTopNavigationHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: const BoxDecoration(color: Color(0xFFF5F7FA)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Back Arrow Button
          InkWell(
            onTap: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).pushReplacementNamed('/home');
              }
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.all(6),
              child: const Icon(
                Icons.arrow_back_rounded,
                size: 24,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          // Center: PennyPal Logo
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 8),
                Flexible(
                  child: Image.asset(
                    AppAssets.headerLogo,
                    height: 32,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.account_balance_wallet,
                            color: AppColors.primaryBlue,
                            size: 22,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'PennyPal',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Right: Search & Notification Icons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Search Icon
              InkWell(
                onTap: () {
                  setState(() {
                    _isSearching = !_isSearching;
                    if (!_isSearching) {
                      _searchController.clear();
                    }
                  });
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    _isSearching ? Icons.close_rounded : Icons.search_rounded,
                    size: 24,
                    color: _isSearching
                        ? AppColors.primaryBlue
                        : AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Notification Bell Icon with indicator dot
              InkWell(
                onTap: () => _showActionSnackbar('Goal Notifications'),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  child: Stack(
                    children: [
                      const Icon(
                        Icons.notifications_outlined,
                        size: 24,
                        color: AppColors.textPrimary,
                      ),
                      Positioned(
                        right: 1,
                        top: 1,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEF4444),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInlineSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textPrimary),
        decoration: InputDecoration(
          icon: const Icon(
            Icons.search_rounded,
            color: AppColors.primaryBlue,
            size: 20,
          ),
          hintText: 'Search goals by name, category, or amount...',
          hintStyle: GoogleFonts.poppins(
            fontSize: 12.5,
            color: AppColors.textSecondary,
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
        onChanged: (_) {
          setState(() {});
        },
      ),
    );
  }

  // ==========================================
  // 3. SCREEN TITLE SECTION
  // ==========================================
  Widget _buildScreenTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Goals',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Dream it. Plan it. Achieve it.',
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 4. TOTAL GOALS SUMMARY CARD
  // ==========================================
  Widget _buildTotalGoalsSummaryCard() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 1. Main Blue Summary Card
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0077F6), Color(0xFF0066EE), Color(0xFF0A58CA)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0066EE).withValues(alpha: 0.28),
                offset: const Offset(0, 8),
                blurRadius: 20,
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(
              children: [
                // Subtle decorative background circles
                Positioned(
                  right: -20,
                  top: -20,
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.06),
                    ),
                  ),
                ),
                Positioned(
                  left: -30,
                  bottom: -30,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.04),
                    ),
                  ),
                ),

                // Transparent card background artwork positioned at bottom-right corner
                Positioned(
                  right: -4,
                  bottom: -6,
                  child: IgnorePointer(
                    child: Image.asset(
                      AppAssets.goalsCardBackground,
                      height: 115,
                      fit: BoxFit.contain,
                      alignment: Alignment.bottomRight,
                      errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                    ),
                  ),
                ),

                // Soft directional gradient overlay for guaranteed text legibility & contrast
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            const Color(0xFF0077F6).withValues(alpha: 0.60),
                            const Color(0xFF0066EE).withValues(alpha: 0.25),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.50, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Row: "Total Goals" Label + Target Icon & Month Dropdown Pill
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    'Total Goals',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.track_changes_rounded,
                                  size: 16,
                                  color: Colors.white70,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Month Selector Dropdown Pill
                          Container(
                            height: 28,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedMonth,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                dropdownColor: const Color(0xFF0066EE),
                                style: GoogleFonts.poppins(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                                items: _availableMonths.map((month) {
                                  return DropdownMenuItem<String>(
                                    value: month,
                                    child: Text(
                                      month,
                                      style: GoogleFonts.poppins(
                                        fontSize: 11.5,
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newVal) {
                                  if (newVal != null) {
                                    setState(() {
                                      _selectedMonth = newVal;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Large Goals Count Headline
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '$_activeGoalsCount',
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Active Goals',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Divider Line
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: Colors.white.withValues(alpha: 0.20),
                      ),
                      const SizedBox(height: 12),

                      // 3-Column Metrics Section: Total Saved | Target Amount | Overall Progress
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 1. Total Saved
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF10B981),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.arrow_upward_rounded,
                                        size: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        'Total Saved',
                                        style: GoogleFonts.poppins(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white.withValues(
                                            alpha: 0.85,
                                          ),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Rs. ${_formatCurrency(_totalSavedAmount)}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Vertical Divider
                          Container(
                            height: 36,
                            width: 1,
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            color: Colors.white.withValues(alpha: 0.20),
                          ),

                          // 2. Target Amount
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.25,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.track_changes_rounded,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        'Target Amount',
                                        style: GoogleFonts.poppins(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white.withValues(
                                            alpha: 0.85,
                                          ),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Rs. ${_formatCurrency(_totalTargetAmount)}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Vertical Divider
                          Container(
                            height: 36,
                            width: 1,
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            color: Colors.white.withValues(alpha: 0.20),
                          ),

                          // 3. Overall Progress (Circular gauge with label underneath)
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 44,
                                  height: 44,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        value: _overallProgress,
                                        strokeWidth: 4.0,
                                        backgroundColor: Colors.white
                                            .withValues(alpha: 0.25),
                                        valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          Color(0xFF34D399),
                                        ),
                                      ),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          '$_overallPercentage%',
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Overall Progress',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // 2. Upper transparent goals hero landscape asset positioned completely above the top edge of the card
        Positioned(
          top: -60,
          right: 8,
          height: 60,
          child: IgnorePointer(
            child: Image.asset(
              AppAssets.goalsHeroLandscape,
              fit: BoxFit.contain,
              alignment: Alignment.bottomRight,
              errorBuilder: (context, error, stackTrace) =>
              const SizedBox.shrink(),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 5. QUICK ACTION GRID (4 Items)
  // ==========================================
  Widget _buildQuickActionsGrid() {
    final actions = [
      _ActionBtnData(
        title: 'Create\nGoal',
        icon: Icons.add_rounded,
        iconColor: Colors.white,
        circleColor: const Color(0xFF10B981),
        onTap: _showCreateGoalBottomSheet,
      ),
      _ActionBtnData(
        title: 'View\nProgress',
        icon: Icons.bar_chart_rounded,
        iconColor: Colors.white,
        circleColor: const Color(0xFF0077F6),
        onTap: () => _showActionSnackbar('Progress Analytics'),
      ),
      _ActionBtnData(
        title: 'Achieved\nGoals',
        icon: Icons.emoji_events_rounded,
        iconColor: Colors.white,
        circleColor: const Color(0xFF8B5CF6),
        onTap: _showAchievedGoalsModal,
      ),
      _ActionBtnData(
        title: 'Goal\nTips',
        icon: Icons.lightbulb_rounded,
        iconColor: Colors.white,
        circleColor: const Color(0xFFF59E0B),
        onTap: _showGoalTipsModal,
      ),
    ];

    return Row(
      children: actions.map((act) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: InkWell(
              onTap: act.onTap,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: act.circleColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(act.icon, color: act.iconColor, size: 22),
                    ),
                    const SizedBox(height: 8),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        act.title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ==========================================
  // 6. YOUR GOALS HEADER
  // ==========================================
  Widget _buildYourGoalsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'Your Goals',
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        InkWell(
          onTap: _showCreateGoalBottomSheet,
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View all',
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 16,
                  color: AppColors.primaryBlue,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 7. GOALS LIST CARDS
  // ==========================================
  Widget _buildGoalsList() {
    final goals = _filteredGoals;

    if (goals.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(
              Icons.track_changes_rounded,
              size: 44,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 10),
            Text(
              'No goals found',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap "+ Add Goal" to start planning your dreams.',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      children: goals.map((g) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.025),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: InkWell(
            onTap: () => _showGoalDetailsModal(g),
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  // Goal Category Pastel Icon Squircle
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: g.iconBgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(g.icon, color: g.iconColor, size: 20),
                  ),
                  const SizedBox(width: 10),

                  // Goal Info Column
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          g.title,
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 1),
                        Text(
                          g.category,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 11,
                              color: Color(0xFF94A3B8),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Target: ${g.targetDate}',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: const Color(0xFF94A3B8),
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Progress & Amounts Column
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Amount Row: Rs. 42,000 / Rs. 1,00,000
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Rs. ${_formatCurrency(g.savedAmount)}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                  ' / Rs. ${_formatCurrency(g.targetAmount)}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Progress Bar + Percentage + Chevron Row: [===] 42% >
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 55,
                                height: 5.5,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE2E8F0),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: FractionallySizedBox(
                                    widthFactor: g.progress,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: g.progressColor,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${g.percentage}%',
                                style: GoogleFonts.poppins(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(width: 2),
                              const Icon(
                                Icons.chevron_right_rounded,
                                size: 16,
                                color: Color(0xFF94A3B8),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ==========================================
  // 8. MOTIVATIONAL BANNER
  // ==========================================
  Widget _buildMotivationalBanner() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFFE8FAF3), Color(0xFFEBF6FE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: const Color(0xFFD1FAE5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            // Decorative background sprout peaking on the right
            Positioned(
              right: -10,
              bottom: -15,
              height: 70,
              child: Opacity(
                opacity: 0.85,
                child: Image.asset(
                  AppAssets.goalsHeroLandscape,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.track_changes_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Small Steps, Big Dreams',
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF065F46),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Stay focused on your goals. Every rupee counts!',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF047857),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // FLOATING ADD GOAL BUTTON
  // ==========================================
  Widget _buildFloatingAddGoalButton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 60, right: 12),
      child: ElevatedButton.icon(
        onPressed: _showCreateGoalBottomSheet,
        icon: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
        label: Text(
          'Add Goal',
          style: GoogleFonts.poppins(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          elevation: 6,
          shadowColor: const Color(0xFF0077F6).withValues(alpha: 0.35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 9. BOTTOM NAVIGATION BAR
  // ==========================================
  Widget _buildBottomNavigationBar() {
    return LiquidGlassBottomNavBar(
      currentIndex: _selectedNavIndex,
      onTap: (index) {
        setState(() {
          _selectedNavIndex = index;
        });
        if (index == 0) {
          Navigator.of(context).pushReplacementNamed('/home');
        } else if (index == 1) {
          Navigator.of(context).pushReplacementNamed('/transactions');
        } else if (index == 2) {
          Navigator.of(context).pushReplacementNamed('/budgets');
        } else if (index != 3) {
          _showActionSnackbar('More');
        }
      },
    );
  }

  // ==========================================
  // MODALS & CREATE GOAL BOTTOM SHEET
  // ==========================================
  void _showCreateGoalBottomSheet() {
    final titleController = TextEditingController();
    final targetController = TextEditingController();
    final initialController = TextEditingController();
    String selectedCat = 'Tech & Equipment';
    String selectedTargetDate = 'Dec 2025';

    final categories = [
      'Tech & Equipment',
      'Travel',
      'Education',
      'Vehicle',
      'Savings & Investment',
      'Emergency Fund',
      'Others',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
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
                      'Create New Goal',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Set a savings target and deadline for your dream.',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Goal Name
                    Text(
                      'Goal Name',
                      style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: titleController,
                      style: GoogleFonts.poppins(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'e.g., MacBook Pro M3, Europe Vacation',
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Category Selector
                    Text(
                      'Category',
                      style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: selectedCat,
                          items: categories.map((cat) {
                            return DropdownMenuItem(
                              value: cat,
                              child: Text(
                                cat,
                                style: GoogleFonts.poppins(fontSize: 13),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setModalState(() {
                                selectedCat = val;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Target Amount
                    Text(
                      'Target Amount (Rs.)',
                      style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: targetController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.poppins(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'e.g., 100000',
                        prefixText: 'Rs. ',
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Initial Saved Amount
                    Text(
                      'Initial Deposit / Saved (Rs.)',
                      style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: initialController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.poppins(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'e.g., 5000 (optional)',
                        prefixText: 'Rs. ',
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Save Goal Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final target =
                              double.tryParse(targetController.text.trim()) ??
                                  50000.0;
                          final initial =
                              double.tryParse(initialController.text.trim()) ??
                                  0.0;
                          final title = titleController.text.trim().isNotEmpty
                              ? titleController.text.trim()
                              : selectedCat;

                          setState(() {
                            _goals.insert(
                              0,
                              GoalItem(
                                id: 'GOL-${DateTime.now().millisecondsSinceEpoch}',
                                title: title,
                                category: selectedCat,
                                savedAmount: initial,
                                targetAmount: target,
                                targetDate: selectedTargetDate,
                                icon: _getIconForCategory(selectedCat),
                                iconBgColor: _getBgColorForCategory(
                                  selectedCat,
                                ),
                                iconColor: _getColorForCategory(selectedCat),
                                progressColor: _getColorForCategory(
                                  selectedCat,
                                ),
                              ),
                            );
                          });

                          Navigator.pop(ctx);
                          _showActionSnackbar('Goal for "$title" created!');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Save Goal',
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
              ),
            );
          },
        );
      },
    );
  }

  void _showGoalDetailsModal(GoalItem goal) {
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
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: goal.iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(goal.icon, color: goal.iconColor, size: 28),
              ),
              const SizedBox(height: 10),
              Text(
                goal.title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                goal.category,
                style: GoogleFonts.poppins(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(
                      'Saved Amount',
                      'Rs. ${_formatCurrency(goal.savedAmount)}',
                    ),
                    const Divider(height: 14),
                    _buildDetailRow(
                      'Target Goal',
                      'Rs. ${_formatCurrency(goal.targetAmount)}',
                    ),
                    const Divider(height: 14),
                    _buildDetailRow(
                      'Remaining',
                      'Rs. ${_formatCurrency(goal.remainingAmount)}',
                    ),
                    const Divider(height: 14),
                    _buildDetailRow('Progress', '${goal.percentage}%'),
                    const Divider(height: 14),
                    _buildDetailRow('Target Date', goal.targetDate),
                  ],
                ),
              ),
              const SizedBox(height: 18),

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
                    'Done',
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

  void _showGoalTipsModal() {
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
                'Smart Savings Tips',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Proven rules of thumb to reach financial milestones faster.',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 14),
              _buildTipRow(
                Icons.schedule_rounded,
                'Automate Transfers',
                'Set aside a fixed amount on the 1st of every month.',
              ),
              const SizedBox(height: 10),
              _buildTipRow(
                Icons.trending_down_rounded,
                'Cut Micro-Expenses',
                'Cooking at home 2 days extra saves Rs. 3,000+ monthly.',
              ),
              const SizedBox(height: 10),
              _buildTipRow(
                Icons.flag_rounded,
                'Milestone Rewards',
                'Celebrate reaching 50% progress with guilt-free treats.',
              ),
              const SizedBox(height: 16),
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
                    'Got It',
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

  void _showAchievedGoalsModal() {
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
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3E8FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: Color(0xFF8B5CF6),
                  size: 26,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Achieved Milestones',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'You have completed 1 goal so far! Keep building wealth.',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF10B981),
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Emergency Buffer Fund',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Completed on April 28, 2025 • Rs. 25,000',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: const Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
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

  Widget _buildTipRow(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Color(0xFFEBF3FE),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primaryBlue, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12.5,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  IconData _getIconForCategory(String cat) {
    switch (cat) {
      case 'Tech & Equipment':
        return Icons.laptop_mac_rounded;
      case 'Travel':
        return Icons.flight_takeoff_rounded;
      case 'Education':
        return Icons.school_rounded;
      case 'Vehicle':
        return Icons.directions_car_rounded;
      case 'Savings & Investment':
        return Icons.account_balance_rounded;
      case 'Emergency Fund':
        return Icons.shield_rounded;
      default:
        return Icons.flag_rounded;
    }
  }

  Color _getColorForCategory(String cat) {
    switch (cat) {
      case 'Tech & Equipment':
        return const Color(0xFF0077F6);
      case 'Travel':
        return const Color(0xFF10B981);
      case 'Education':
        return const Color(0xFF8B5CF6);
      case 'Vehicle':
        return const Color(0xFFF59E0B);
      case 'Savings & Investment':
        return const Color(0xFF0284C7);
      case 'Emergency Fund':
        return const Color(0xFF10B981);
      default:
        return const Color(0xFF6366F1);
    }
  }

  Color _getBgColorForCategory(String cat) {
    switch (cat) {
      case 'Tech & Equipment':
        return const Color(0xFFEBF3FE);
      case 'Travel':
        return const Color(0xFFE8FAF3);
      case 'Education':
        return const Color(0xFFF3E8FF);
      case 'Vehicle':
        return const Color(0xFFFEF3C7);
      case 'Savings & Investment':
        return const Color(0xFFE0F2FE);
      case 'Emergency Fund':
        return const Color(0xFFDCFCE7);
      default:
        return const Color(0xFFEEF2FF);
    }
  }

  void _showActionSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$msg is actively synchronized with your PennyPal account.',
          style: GoogleFonts.poppins(fontSize: 12.5),
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _ActionBtnData {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color circleColor;
  final VoidCallback onTap;

  const _ActionBtnData({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.circleColor,
    required this.onTap,
  });
}
