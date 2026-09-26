import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../widgets/liquid_glass_bottom_nav_bar.dart';

/// Model representing an individual budget category in PennyPal.
class BudgetItem {
  final String id;
  final String categoryName;
  final String subDescription;
  final String dateRange;
  final double budgetLimit;
  final double spentAmount;
  final IconData categoryIcon;
  final Color iconBgColor;
  final Color iconColor;
  final Color progressColor;

  const BudgetItem({
    required this.id,
    required this.categoryName,
    required this.subDescription,
    required this.dateRange,
    required this.budgetLimit,
    required this.spentAmount,
    required this.categoryIcon,
    required this.iconBgColor,
    required this.iconColor,
    required this.progressColor,
  });

  double get progress => (spentAmount / budgetLimit).clamp(0.0, 1.0);
  int get percentage => (progress * 100).round();
  double get remaining =>
      (budgetLimit - spentAmount).clamp(0.0, double.infinity);
}

/// PennyPal Budget Screen for managing monthly budgets, category limits,
/// tracking spending progress, and building smart financial habits.
class BudgetScreen extends StatefulWidget {
  final bool showBottomNav;

  const BudgetScreen({super.key, this.showBottomNav = true});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final TextEditingController _searchController = TextEditingController();

  bool _isSearching = false;
  String _selectedMonth = 'May 2025';
  int _selectedNavIndex = 2; // Budgets is active (index 2)

  final List<String> _availableMonths = [
    'May 2025',
    'April 2025',
    'March 2025',
    'February 2025',
    'January 2025',
  ];

  late List<BudgetItem> _budgets;

  @override
  void initState() {
    super.initState();
    _initBudgetsData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _initBudgetsData() {
    _budgets = [
      const BudgetItem(
        id: 'BDG-001',
        categoryName: 'Food & Dining',
        subDescription: 'Restaurants, Cafes, Groceries',
        dateRange: 'May 1 – May 31, 2025',
        budgetLimit: 3000,
        spentAmount: 1887,
        categoryIcon: Icons.restaurant_rounded,
        iconBgColor: Color(0xFFFEECEC),
        iconColor: Color(0xFFEF4444),
        progressColor: Color(0xFFEF4444),
      ),
      const BudgetItem(
        id: 'BDG-002',
        categoryName: 'Transport',
        subDescription: 'Bus, Fuel, Rides',
        dateRange: 'May 1 – May 31, 2025',
        budgetLimit: 2000,
        spentAmount: 1221,
        categoryIcon: Icons.directions_bus_rounded,
        iconBgColor: Color(0xFFF3E8FF),
        iconColor: Color(0xFF8B5CF6),
        progressColor: Color(0xFF8B5CF6),
      ),
      const BudgetItem(
        id: 'BDG-003',
        categoryName: 'Shopping',
        subDescription: 'Clothes, Electronics, General',
        dateRange: 'May 1 – May 31, 2025',
        budgetLimit: 2000,
        spentAmount: 1899,
        categoryIcon: Icons.shopping_bag_rounded,
        iconBgColor: Color(0xFFEBF3FE),
        iconColor: Color(0xFF0077F6),
        progressColor: Color(0xFF0077F6),
      ),
      const BudgetItem(
        id: 'BDG-004',
        categoryName: 'Education',
        subDescription: 'Books, Courses, Learning',
        dateRange: 'May 1 – May 31, 2025',
        budgetLimit: 2000,
        spentAmount: 777,
        categoryIcon: Icons.school_rounded,
        iconBgColor: Color(0xFFF3E8FF),
        iconColor: Color(0xFF8B5CF6),
        progressColor: Color(0xFF6366F1),
      ),
      const BudgetItem(
        id: 'BDG-005',
        categoryName: 'Others',
        subDescription: 'Miscellaneous, Subscriptions',
        dateRange: 'May 1 – May 31, 2025',
        budgetLimit: 1000,
        spentAmount: 666,
        categoryIcon: Icons.category_rounded,
        iconBgColor: Color(0xFFFEF3C7),
        iconColor: Color(0xFFF59E0B),
        progressColor: Color(0xFFF59E0B),
      ),
    ];
  }

  double get _totalBudget =>
      _budgets.fold(0.0, (sum, item) => sum + item.budgetLimit);
  double get _totalSpent =>
      _budgets.fold(0.0, (sum, item) => sum + item.spentAmount);
  double get _remainingBudget =>
      (_totalBudget - _totalSpent).clamp(0.0, double.infinity);
  double get _overallProgress =>
      _totalBudget > 0 ? (_totalSpent / _totalBudget).clamp(0.0, 1.0) : 0.0;
  int get _overallPercentage => (_overallProgress * 100).round();

  List<BudgetItem> get _filteredBudgets {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return _budgets;
    return _budgets.where((b) {
      return b.categoryName.toLowerCase().contains(query) ||
          b.subDescription.toLowerCase().contains(query) ||
          b.budgetLimit.toString().contains(query) ||
          b.spentAmount.toString().contains(query);
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
                        // 3. Screen Title Section
                        _buildScreenTitleSection(),
                        const SizedBox(height: 65),

                        // 4. Monthly Budget Overview Card
                        _buildMonthlyBudgetOverviewCard(),
                        const SizedBox(height: 18),

                        // 5. Quick Action Grid (4 Actions)
                        _buildQuickActionsGrid(),
                        const SizedBox(height: 22),

                        // 6. Your Budgets Section Header
                        _buildYourBudgetsHeader(),
                        const SizedBox(height: 12),

                        // 7. Budget Category List Cards
                        _buildBudgetCategoriesList(),
                        const SizedBox(height: 18),

                        // 8. Motivational Financial Growth Card
                        _buildMotivationalCard(),
                        SizedBox(height: widget.showBottomNav ? 24 : 85),
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
                Image.asset(
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
              ],
            ),
          ),

          // Right: Search & Filter Icons
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

              // Filter / Menu Icon
              InkWell(
                onTap: _showManageLimitsModal,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  child: const Icon(
                    Icons.tune_rounded,
                    size: 24,
                    color: AppColors.textPrimary,
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
          hintText: 'Search budgets by category or limit...',
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
          'Budgets',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Plan your spending, achieve your goals.',
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
  // 4. MONTHLY BUDGET OVERVIEW CARD
  // ==========================================
  Widget _buildMonthlyBudgetOverviewCard() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 1. Main Card Container
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
                // Subtle decorative background circles for depth
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

                // Inner landscape decorative asset positioned inside the card flush at bottom-right corner
                Positioned(
                  right: -2,
                  bottom: -6,
                  child: IgnorePointer(
                    child: Image.asset(
                      AppAssets.balanceInnerAsset,
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
                            const Color(0xFF0077F6).withValues(alpha: 0.55),
                            const Color(0xFF0066EE).withValues(alpha: 0.20),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.45, 1.0],
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
                      // Top Row: "Monthly Budget" Label + Target Icon & Month Dropdown Pill
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    'Monthly Budget',
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
                                const SizedBox(width: 4),
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

                      // Spent Amount Headline
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Rs. ${_formatCurrency(_totalSpent)}',
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),

                      // Total Budget Subtitle
                      Text(
                        'of Rs. ${_formatCurrency(_totalBudget)}',
                        style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Horizontal Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Stack(
                          children: [
                            Container(
                              height: 8,
                              width: double.infinity,
                              color: Colors.white.withValues(alpha: 0.25),
                            ),
                            FractionallySizedBox(
                              widthFactor: _overallProgress,
                              child: Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF10B981),
                                      Color(0xFF34D399),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Progress Percentage Label
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$_overallPercentage% used',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'Remaining: Rs. ${_formatCurrency(_remainingBudget)}',
                              style: GoogleFonts.poppins(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
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

        // 2. Upper decorative landscape asset positioned completely above the top edge of the card at far right
        Positioned(
          top: -60,
          right: 8,
          height: 60,
          child: IgnorePointer(
            child: Image.asset(
              AppAssets.balanceUpperAsset,
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
        title: 'Create\nBudget',
        icon: Icons.add_rounded,
        iconColor: Colors.white,
        circleColor: const Color(0xFF10B981),
        onTap: _showCreateBudgetBottomSheet,
      ),
      _ActionBtnData(
        title: 'View\nReports',
        icon: Icons.pie_chart_rounded,
        iconColor: Colors.white,
        circleColor: const Color(0xFF0077F6),
        onTap: () => _showActionSnackbar('Reports & Analytics'),
      ),
      _ActionBtnData(
        title: 'Set\nGoals',
        icon: Icons.track_changes_rounded,
        iconColor: Colors.white,
        circleColor: const Color(0xFF8B5CF6),
        onTap: () => _showActionSnackbar('Savings Goals Sync'),
      ),
      _ActionBtnData(
        title: 'Manage\nLimits',
        icon: Icons.tune_rounded,
        iconColor: Colors.white,
        circleColor: const Color(0xFFF59E0B),
        onTap: _showManageLimitsModal,
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
                        shape: BoxShape.circle,
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
  // 6. YOUR BUDGETS HEADER
  // ==========================================
  Widget _buildYourBudgetsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'Your Budgets',
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        InkWell(
          onTap: _showCreateBudgetBottomSheet,
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
  // 7. BUDGET CATEGORIES LIST
  // ==========================================
  Widget _buildBudgetCategoriesList() {
    final budgets = _filteredBudgets;

    if (budgets.isEmpty) {
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
              Icons.pie_chart_outline_rounded,
              size: 44,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 10),
            Text(
              'No budgets found',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap "+ Create Budget" to set up your first category limit.',
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
      children: budgets.map((b) {
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
            onTap: () => _showBudgetDetailsModal(b),
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  // Category Pastel Icon
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: b.iconBgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(b.categoryIcon, color: b.iconColor, size: 22),
                  ),
                  const SizedBox(width: 12),

                  // Category Info Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          b.categoryName,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 1),
                        Text(
                          b.subDescription,
                          style: GoogleFonts.poppins(
                            fontSize: 11.5,
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
                                b.dateRange,
                                style: GoogleFonts.poppins(
                                  fontSize: 10.5,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Rs. ${_formatCurrency(b.spentAmount)}',
                            style: GoogleFonts.poppins(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.chevron_right_rounded,
                            size: 18,
                            color: Color(0xFF94A3B8),
                          ),
                        ],
                      ),
                      Text(
                        'of Rs. ${_formatCurrency(b.budgetLimit)}',
                        style: GoogleFonts.poppins(
                          fontSize: 10.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Progress Bar
                      Container(
                        width: 85,
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: b.progress,
                            child: Container(
                              decoration: BoxDecoration(
                                color: b.progressColor,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${b.percentage}% used',
                        style: GoogleFonts.poppins(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          color: b.progressColor,
                        ),
                      ),
                    ],
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
  // 8. MOTIVATIONAL FINANCIAL GROWTH CARD
  // ==========================================
  Widget _buildMotivationalCard() {
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
                  AppAssets.balanceUpperAsset,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                              'Build Better Money Habits',
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF065F46),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Stay on track, manage your spending, and grow your savings.',
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
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: _showManageLimitsModal,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF10B981,
                              ).withValues(alpha: 0.25),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Manage Budgets',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              size: 14,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
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
        } else if (index == 3) {
          Navigator.of(context).pushReplacementNamed('/goals');
        } else if (index != 2) {
          _showActionSnackbar('More');
        }
      },
    );
  }

  // ==========================================
  // MODALS & CREATE BUDGET BOTTOM SHEET
  // ==========================================
  void _showCreateBudgetBottomSheet() {
    final nameController = TextEditingController();
    final limitController = TextEditingController();
    String selectedCat = 'Food & Dining';

    final categories = [
      'Food & Dining',
      'Transport',
      'Shopping',
      'Education',
      'Entertainment',
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
                    'Create New Budget',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Set a spending threshold for this category.',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),

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

                  // Budget Name
                  Text(
                    'Budget Name / Note',
                    style: GoogleFonts.poppins(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: nameController,
                    style: GoogleFonts.poppins(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'e.g., Weekly Groceries & Dining',
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Monthly Limit Amount
                  Text(
                    'Monthly Limit (Rs.)',
                    style: GoogleFonts.poppins(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: limitController,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.poppins(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'e.g., 3500',
                      prefixText: 'Rs. ',
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final limit =
                            double.tryParse(limitController.text.trim()) ??
                            3000.0;
                        final note = nameController.text.trim().isNotEmpty
                            ? nameController.text.trim()
                            : selectedCat;

                        setState(() {
                          _budgets.insert(
                            0,
                            BudgetItem(
                              id: 'BDG-${DateTime.now().millisecondsSinceEpoch}',
                              categoryName: selectedCat,
                              subDescription: note,
                              dateRange: 'May 1 – May 31, 2025',
                              budgetLimit: limit,
                              spentAmount: 0.0,
                              categoryIcon: _getIconForCategory(selectedCat),
                              iconBgColor: _getBgColorForCategory(selectedCat),
                              iconColor: _getColorForCategory(selectedCat),
                              progressColor: _getColorForCategory(selectedCat),
                            ),
                          );
                        });

                        Navigator.pop(ctx);
                        _showActionSnackbar('Budget for $selectedCat created!');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Save Budget',
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
      },
    );
  }

  void _showBudgetDetailsModal(BudgetItem budget) {
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
                  color: budget.iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  budget.categoryIcon,
                  color: budget.iconColor,
                  size: 28,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                budget.categoryName,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                budget.subDescription,
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
                      'Budget Limit',
                      'Rs. ${_formatCurrency(budget.budgetLimit)}',
                    ),
                    const Divider(height: 14),
                    _buildDetailRow(
                      'Amount Spent',
                      'Rs. ${_formatCurrency(budget.spentAmount)}',
                    ),
                    const Divider(height: 14),
                    _buildDetailRow(
                      'Remaining',
                      'Rs. ${_formatCurrency(budget.remaining)}',
                    ),
                    const Divider(height: 14),
                    _buildDetailRow('Progress', '${budget.percentage}% used'),
                    const Divider(height: 14),
                    _buildDetailRow('Period', budget.dateRange),
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

  void _showManageLimitsModal() {
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
                'Manage Spending Limits',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Adjust budget alerts and automatic rollover preferences.',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.notifications_active_rounded,
                  color: Color(0xFF0077F6),
                ),
                title: Text(
                  '80% Threshold Alert',
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'Notify me when 80% of budget is reached',
                  style: GoogleFonts.poppins(fontSize: 11),
                ),
                trailing: Switch(
                  value: true,
                  activeTrackColor: AppColors.primaryBlue,
                  onChanged: (_) {},
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.auto_mode_rounded,
                  color: Color(0xFF10B981),
                ),
                title: Text(
                  'Auto-Rollover Unused',
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'Roll remaining budget to next month',
                  style: GoogleFonts.poppins(fontSize: 11),
                ),
                trailing: Switch(
                  value: false,
                  activeTrackColor: AppColors.primaryBlue,
                  onChanged: (_) {},
                ),
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
                    'Save Preferences',
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
      case 'Food & Dining':
        return Icons.restaurant_rounded;
      case 'Transport':
        return Icons.directions_bus_rounded;
      case 'Shopping':
        return Icons.shopping_bag_rounded;
      case 'Education':
        return Icons.school_rounded;
      case 'Entertainment':
        return Icons.movie_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  Color _getColorForCategory(String cat) {
    switch (cat) {
      case 'Food & Dining':
        return const Color(0xFFEF4444);
      case 'Transport':
        return const Color(0xFF8B5CF6);
      case 'Shopping':
        return const Color(0xFF0077F6);
      case 'Education':
        return const Color(0xFF6366F1);
      case 'Entertainment':
        return const Color(0xFFEC4899);
      default:
        return const Color(0xFFF59E0B);
    }
  }

  Color _getBgColorForCategory(String cat) {
    switch (cat) {
      case 'Food & Dining':
        return const Color(0xFFFEECEC);
      case 'Transport':
        return const Color(0xFFF3E8FF);
      case 'Shopping':
        return const Color(0xFFEBF3FE);
      case 'Education':
        return const Color(0xFFF3E8FF);
      case 'Entertainment':
        return const Color(0xFFFCE7F3);
      default:
        return const Color(0xFFFEF3C7);
    }
  }

  void _showActionSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$msg feature is synchronized with your PennyPal account.',
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
