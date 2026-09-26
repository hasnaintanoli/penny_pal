import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:penny_pal/screens/add_expense.dart';
import 'package:penny_pal/screens/add_transcation.dart';
import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../widgets/spending_donut_chart.dart';
import '../widgets/liquid_glass_bottom_nav_bar.dart';

/// Model representing a transaction record.
class TransactionRecord {
  final String id;
  final String title;
  final String description;
  final String date;
  final double amount;
  final bool isIncome;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;

  const TransactionRecord({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.amount,
    required this.isIncome,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
  });
}

/// Model representing a savings goal.
class SavingsGoalItem {
  final String title;
  final double currentAmount;
  final double targetAmount;
  final String deadline;
  final bool isCompleted;

  const SavingsGoalItem({
    required this.title,
    required this.currentAmount,
    required this.targetAmount,
    required this.deadline,
    this.isCompleted = false,
  });

  double get progress => (currentAmount / targetAmount).clamp(0.0, 1.0);
}

/// PennyPal Home Screen dashboard for student personal finance management.
class HomeScreen extends StatefulWidget {
  final String userName;
  final bool showBottomNav;

  const HomeScreen({
    super.key,
    this.userName = 'Hasnain',
    this.showBottomNav = true,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isBalanceVisible = true;
  String _selectedMonth = 'May 2025';
  int _selectedNavIndex = 0;

  final List<String> _availableMonths = [
    'May 2025',
    'April 2025',
    'March 2025',
    'February 2025',
    'January 2025',
  ];

  late List<TransactionRecord> _transactions;
  late List<SavingsGoalItem> _savingsGoals;

  @override
  void initState() {
    super.initState();
    _initSampleData();
  }

  void _initSampleData() {
    _transactions = [
      const TransactionRecord(
        id: 'TXN-101',
        title: 'Food & Dining',
        description: "McDonald's",
        date: 'May 12, 2025',
        amount: 450,
        isIncome: false,
        icon: Icons.restaurant_rounded,
        iconColor: AppColors.accentGreen,
        iconBgColor: Color(0xFFE8F8F2),
      ),
      const TransactionRecord(
        id: 'TXN-102',
        title: 'Freelance Work',
        description: 'Upwork Payment',
        date: 'May 11, 2025',
        amount: 8000,
        isIncome: true,
        icon: Icons.work_rounded,
        iconColor: AppColors.primaryBlue,
        iconBgColor: Color(0xFFEBF3FE),
      ),
      const TransactionRecord(
        id: 'TXN-103',
        title: 'Transport',
        description: 'Bus Fare',
        date: 'May 10, 2025',
        amount: 200,
        isIncome: false,
        icon: Icons.directions_bus_rounded,
        iconColor: AppColors.error,
        iconBgColor: Color(0xFFFEECEC),
      ),
    ];

    _savingsGoals = [
      const SavingsGoalItem(
        title: 'Emergency Fund',
        currentAmount: 15000,
        targetAmount: 15000,
        deadline: 'Jun 2025',
        isCompleted: true,
      ),
      const SavingsGoalItem(
        title: 'New Laptop',
        currentAmount: 35000,
        targetAmount: 85000,
        deadline: 'Aug 2025',
        isCompleted: false,
      ),
      const SavingsGoalItem(
        title: 'Course Certification',
        currentAmount: 6000,
        targetAmount: 12000,
        deadline: 'Jul 2025',
        isCompleted: false,
      ),
    ];
  }

  double get _totalIncome => 18000.0;
  double get _totalExpenses => 5550.0;
  double get _totalBalance => _totalIncome - _totalExpenses;

  List<SpendingCategoryData> get _spendingCategories => const [
    SpendingCategoryData(
      title: 'Food & Dining',
      amount: 1887,
      percentage: 34,
      color: AppColors.categoryFood,
    ),
    SpendingCategoryData(
      title: 'Transport',
      amount: 1221,
      percentage: 22,
      color: AppColors.categoryTransport,
    ),
    SpendingCategoryData(
      title: 'Shopping',
      amount: 999,
      percentage: 18,
      color: AppColors.categoryShopping,
    ),
    SpendingCategoryData(
      title: 'Education',
      amount: 777,
      percentage: 14,
      color: AppColors.categoryEducation,
    ),
    SpendingCategoryData(
      title: 'Others',
      amount: 666,
      percentage: 12,
      color: AppColors.categoryOthers,
    ),
  ];

  int get _completedGoalsCount =>
      _savingsGoals.where((g) => g.isCompleted || g.progress >= 1.0).length;

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

  String _getGreetingPrefix() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF5F7FA),
      drawer: _buildDrawer(),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              children: [
                // Top Header / Navigation
                _buildTopHeader(),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // B. Greeting Section
                        _buildGreetingSection(),
                        const SizedBox(height: 65),

                        // C. Total Balance Card
                        _buildTotalBalanceCard(),
                        const SizedBox(height: 20),

                        // D. Quick Action Buttons
                        _buildQuickActionsSection(),
                        const SizedBox(height: 20),

                        // E. Spending Overview Section
                        _buildSpendingOverviewSection(),
                        const SizedBox(height: 20),

                        // F. Savings Goals Section
                        _buildSavingsGoalsSection(),
                        const SizedBox(height: 20),

                        // G. Recent Transactions Section
                        _buildRecentTransactionsSection(),
                        SizedBox(height: widget.showBottomNav ? 24 : 85),
                      ],
                    ),
                  ),
                ),

                // H. Bottom Navigation Bar
                if (widget.showBottomNav) _buildBottomNavigationBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // A. TOP HEADER / NAVIGATION
  // ==========================================
  Widget _buildTopHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: const BoxDecoration(color: Color(0xFFF5F7FA)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Hamburger Menu Icon
          InkWell(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.all(6),
              child: const Icon(
                Icons.menu_rounded,
                size: 26,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          // Center: PennyPal Logo
          Expanded(
            child: Center(
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
                        size: 24,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'PennyPal',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // Right: Notification Bell & Profile Avatar
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Notification Bell with Badge Dot
              Stack(
                clipBehavior: Clip.none,
                children: [
                  InkWell(
                    onTap: _showNotificationsSheet,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      child: const Icon(
                        Icons.notifications_outlined,
                        size: 24,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
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
              const SizedBox(width: 8),

              // User Profile Avatar
              GestureDetector(
                onTap: _showProfileSheet,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFE0E7FF),
                    border: Border.all(
                      color: AppColors.primaryBlue.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      widget.userName.isNotEmpty
                          ? widget.userName[0].toUpperCase()
                          : 'H',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // B. GREETING SECTION
  // ==========================================
  Widget _buildGreetingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                '${_getGreetingPrefix()}, ${widget.userName}!',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.4,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6),
            const _WavingHandEmoji(),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          'Small steps today, big dreams tomorrow.',
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
  // C. TOTAL BALANCE CARD
  // ==========================================
  Widget _buildTotalBalanceCard() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 1. Main Total Balance Card Container
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

                // Inner landscape decorative asset positioned inside the card flush with bottom-right corner
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
                      // Top row: Total Balance + Eye toggle & Month Selector Dropdown
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Balance Title & Eye Toggle
                          Flexible(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    'Total Balance',
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
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isBalanceVisible = !_isBalanceVisible;
                                    });
                                  },
                                  child: Icon(
                                    _isBalanceVisible
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 18,
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
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

                      // Total Balance Amount
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _isBalanceVisible
                              ? 'Rs. ${_formatCurrency(_totalBalance)}'
                              : '••••••••',
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Income & Expenses Summary Row
                      Row(
                        children: [
                          // Income Column
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF10B981),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Income',
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white.withValues(
                                            alpha: 0.85,
                                          ),
                                        ),
                                      ),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          _isBalanceVisible
                                              ? 'Rs. ${_formatCurrency(_totalIncome)}'
                                              : '••••••',
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
                              ],
                            ),
                          ),

                          // Vertical Divider
                          Container(
                            width: 1,
                            height: 28,
                            color: Colors.white.withValues(alpha: 0.25),
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                          ),

                          // Expenses Column
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFEF4444),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.remove_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Expenses',
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white.withValues(
                                            alpha: 0.85,
                                          ),
                                        ),
                                      ),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          _isBalanceVisible
                                              ? 'Rs. ${_formatCurrency(_totalExpenses)}'
                                              : '••••••',
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

        // 2. Upper decorative landscape asset positioned completely above the top edge of the card
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
  // D. QUICK ACTION BUTTONS (6 Items)
  // ==========================================
  Widget _buildQuickActionsSection() {
    final actions = [
      _QuickActionData(
        title: 'Add Income',
        icon: Icons.add_rounded,
        iconColor: AppColors.actionGreenIcon,
        bgColor: AppColors.actionGreenBg,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddIncomeScreen())),
      ),
      _QuickActionData(
        title: 'Add Expense',
        icon: Icons.remove_rounded,
        iconColor: AppColors.actionRedIcon,
        bgColor: AppColors.actionRedBg,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
      ),


      ),
      _QuickActionData(
        title: 'AI Assistant',
        icon: Icons.smart_toy_rounded,
        iconColor: AppColors.actionSkyIcon,
        bgColor: AppColors.actionSkyBg,
        onTap: () => _showFeaturePlaceholder(
          'Penny AI Assistant',
          'Your 24/7 personal student financial advisor. Ask how to save on groceries, track receipts, and plan your college budget!',
        ),
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: actions.map((action) {
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: _buildActionTile(action),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActionTile(_QuickActionData action) {
    return InkWell(
      onTap: action.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 68,
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: action.bgColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Icon(action.icon, color: action.iconColor, size: 24),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              action.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: GoogleFonts.poppins(
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                height: 1.15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // E. SPENDING OVERVIEW SECTION
  // ==========================================
  Widget _buildSpendingOverviewSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.borderLight, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Title & Subtitle
          Text(
            'Spending Overview',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'This Month • Rs. ${_formatCurrency(_totalExpenses)}',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),

          // Chart + Category Breakdown Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: Donut Chart
              SpendingDonutChart(
                categories: _spendingCategories,
                totalAmount: _totalExpenses,
                size: 92,
                strokeWidth: 17,
              ),
              const SizedBox(width: 10),

              // Right: Category List
              Expanded(
                child: Column(
                  children: _spendingCategories.map((category) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Row(
                        children: [
                          // Color Dot
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: category.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),

                          // Category Name
                          Expanded(
                            child: Text(
                              category.title,
                              style: GoogleFonts.poppins(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),

                          // Percentage
                          Text(
                            '${category.percentage.toInt()}%',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 4),

                          // Amount
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Rs. ${_formatCurrency(category.amount)}',
                              style: GoogleFonts.poppins(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // F. SAVINGS GOALS SECTION
  // ==========================================
  Widget _buildSavingsGoalsSection() {
    final totalGoals = _savingsGoals.length;
    final completedGoals = _completedGoalsCount;
    final progress = totalGoals > 0 ? (completedGoals / totalGoals) : 0.0;

    return InkWell(
      onTap: _showSavingsGoalsModal,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: AppColors.savingsCardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.savingsCardBorder, width: 1.2),
        ),
        child: Row(
          children: [
            // Left: Piggy Bank PNG Container
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFD1FAE5).withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  AppAssets.piggyBank,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.savings_rounded,
                      color: AppColors.accentGreen,
                      size: 30,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Middle Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Savings Goals',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    'Build your future, one goal at a time.',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF4B5563),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$completedGoals of $totalGoals goals',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentGreen,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress > 0 ? progress : 0.33,
                      minHeight: 5,
                      backgroundColor: AppColors.savingsTrack,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.savingsProgress,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),

            // Right Arrow
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF9CA3AF),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // G. RECENT TRANSACTIONS SECTION
  // ==========================================
  Widget _buildRecentTransactionsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.borderLight, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Title + View All
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Recent Transactions',
                  style: GoogleFonts.poppins(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              InkWell(
                onTap: () => Navigator.of(context).pushNamed('/transactions'),
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  child: Text(
                    'View All',
                    style: GoogleFonts.poppins(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Transactions List
          if (_transactions.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Center(
                child: Text(
                  'No recent transactions found.',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _transactions.length,
              separatorBuilder: (context, index) => const Divider(
                color: Color(0xFFF1F5F9),
                height: 14,
                thickness: 1,
              ),
              itemBuilder: (context, index) {
                final txn = _transactions[index];
                return InkWell(
                  onTap: () => _showTransactionDetailsModal(txn),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                    child: Row(
                      children: [
                        // Category Icon
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: txn.iconBgColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Icon(
                              txn.icon,
                              color: txn.iconColor,
                              size: 19,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),

                        // Title, Description & Date
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                txn.title,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${txn.description} • ${txn.date}',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textSecondary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        // Amount & Chevron Arrow
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              txn.isIncome
                                  ? '+ Rs. ${_formatCurrency(txn.amount)}'
                                  : '- Rs. ${_formatCurrency(txn.amount)}',
                              style: GoogleFonts.poppins(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: txn.isIncome
                                    ? AppColors.accentGreen
                                    : AppColors.error,
                              ),
                            ),
                            const SizedBox(width: 2),
                            const Icon(
                              Icons.chevron_right_rounded,
                              size: 18,
                              color: Color(0xFFCBD5E1),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // ==========================================
  // H. BOTTOM NAVIGATION BAR
  // ==========================================
  Widget _buildBottomNavigationBar() {
    return LiquidGlassBottomNavBar(
      currentIndex: _selectedNavIndex,
      onTap: (index) {
        setState(() {
          _selectedNavIndex = index;
        });
        if (index == 1) {
          Navigator.of(context).pushReplacementNamed('/transactions');
        } else if (index == 2) {
          Navigator.of(context).pushReplacementNamed('/budgets');
        } else if (index == 3) {
          Navigator.of(context).pushReplacementNamed('/goals');
        } else if (index == 4) {
          _handleBottomNavTap('More');
        }
      },
    );
  }

  // ==========================================
  // DRAWER MENU
  // ==========================================
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0077F6), Color(0xFF0A58CA)],
              ),
            ),
            accountName: Text(
              widget.userName,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            accountEmail: Text(
              'student@pennypal.app',
              style: GoogleFonts.poppins(
                fontSize: 12.5,
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                widget.userName.isNotEmpty
                    ? widget.userName[0].toUpperCase()
                    : 'H',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.dashboard_rounded,
              color: AppColors.primaryBlue,
            ),
            title: Text(
              'Dashboard',
              style: GoogleFonts.poppins(fontSize: 13.5),
            ),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(
              Icons.swap_horiz_rounded,
              color: AppColors.textSecondary,
            ),
            title: Text(
              'Transactions',
              style: GoogleFonts.poppins(fontSize: 13.5),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/transactions');
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.pie_chart_rounded,
              color: AppColors.textSecondary,
            ),
            title: Text(
              'Budget Planner',
              style: GoogleFonts.poppins(fontSize: 13.5),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/budgets');
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.track_changes_rounded,
              color: AppColors.textSecondary,
            ),
            title: Text(
              'Savings Goals',
              style: GoogleFonts.poppins(fontSize: 13.5),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/goals');
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.menu_book_rounded,
              color: AppColors.textSecondary,
            ),
            title: Text(
              'Financial Learning',
              style: GoogleFonts.poppins(fontSize: 13.5),
            ),
            onTap: () {
              Navigator.pop(context);
              _showFeaturePlaceholder(
                'Financial Learning',
                'Explore student finance tutorials.',
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.smart_toy_rounded,
              color: AppColors.textSecondary,
            ),
            title: Text(
              'Penny AI Assistant',
              style: GoogleFonts.poppins(fontSize: 13.5),
            ),
            onTap: () {
              Navigator.pop(context);
              _showFeaturePlaceholder(
                'Penny AI',
                'Chat with your AI financial advisor.',
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.settings_rounded,
              color: AppColors.textSecondary,
            ),
            title: Text('Settings', style: GoogleFonts.poppins(fontSize: 13.5)),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: AppColors.error),
            title: Text(
              'Logout',
              style: GoogleFonts.poppins(
                fontSize: 13.5,
                color: AppColors.error,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }

  // ==========================================
  // MODALS & ACTIONS
  // ==========================================
  void _handleBottomNavTap(String label) {
    if (label == 'Transactions') {
      Navigator.of(context).pushNamed('/transactions');
      return;
    }
    if (label == 'Budgets') {
      Navigator.of(context).pushNamed('/budgets');
      return;
    }
    if (label == 'Goals') {
      Navigator.of(context).pushNamed('/goals');
      return;
    }
    _showFeaturePlaceholder(
      label,
      'The $label feature is actively synchronized with your PennyPal student account.',
    );
  }

  void _showAddTransactionModal({required bool isIncome}) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final amountController = TextEditingController();
    String selectedCategory = isIncome ? 'Freelance Work' : 'Food & Dining';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isIncome
                          ? AppColors.actionGreenBg
                          : AppColors.actionRedBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isIncome ? Icons.add_rounded : Icons.remove_rounded,
                      color: isIncome ? AppColors.accentGreen : AppColors.error,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    isIncome ? 'Add New Income' : 'Add New Expense',
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title / Category',
                  hintText: isIncome
                      ? 'e.g., Allowance, Freelance'
                      : 'e.g., McDonald\'s, Groceries',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                decoration: InputDecoration(
                  labelText: 'Merchant / Description',
                  hintText: 'e.g., Semester Project, Bus Fare',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount (PKR)',
                  hintText: 'e.g., 500',
                  prefixText: 'Rs. ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isIncome
                        ? AppColors.accentGreen
                        : AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    final enteredAmount =
                        double.tryParse(amountController.text.trim()) ?? 0;
                    if (enteredAmount > 0 &&
                        titleController.text.trim().isNotEmpty) {
                      setState(() {
                        _transactions.insert(
                          0,
                          TransactionRecord(
                            id: 'TXN-${DateTime.now().millisecondsSinceEpoch % 10000}',
                            title: titleController.text.trim(),
                            description: descController.text.trim().isNotEmpty
                                ? descController.text.trim()
                                : selectedCategory,
                            date: 'Today',
                            amount: enteredAmount,
                            isIncome: isIncome,
                            icon: isIncome
                                ? Icons.account_balance_wallet_rounded
                                : Icons.shopping_bag_rounded,
                            iconColor: isIncome
                                ? AppColors.accentGreen
                                : AppColors.error,
                            iconBgColor: isIncome
                                ? AppColors.actionGreenBg
                                : AppColors.actionRedBg,
                          ),
                        );
                      });
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${isIncome ? "Income" : "Expense"} of Rs. ${_formatCurrency(enteredAmount)} added successfully!',
                            style: GoogleFonts.poppins(),
                          ),
                          backgroundColor: AppColors.accentGreen,
                        ),
                      );
                    }
                  },
                  child: Text(
                    isIncome ? 'Save Income' : 'Save Expense',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
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

  void _showTransactionDetailsModal(TransactionRecord txn) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
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
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: txn.iconBgColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(txn.icon, color: txn.iconColor, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          txn.title,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          txn.description,
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    txn.isIncome
                        ? '+ Rs. ${_formatCurrency(txn.amount)}'
                        : '- Rs. ${_formatCurrency(txn.amount)}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: txn.isIncome
                          ? AppColors.accentGreen
                          : AppColors.error,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              _buildDetailRow('Transaction ID', txn.id),
              _buildDetailRow('Date', txn.date),
              _buildDetailRow(
                'Type',
                txn.isIncome ? 'Credit / Income' : 'Debit / Expense',
              ),
              _buildDetailRow('Payment Status', 'Completed', isBadge: true),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Close', style: GoogleFonts.poppins()),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBadge = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              color: AppColors.textSecondary,
            ),
          ),
          if (isBadge)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFD1FAE5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accentGreen,
                ),
              ),
            )
          else
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
        ],
      ),
    );
  }

  void _showSavingsGoalsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
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
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1FAE5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        AppAssets.piggyBank,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Student Savings Goals',
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '$_completedGoalsCount of ${_savingsGoals.length} goals achieved',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.accentGreen,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ..._savingsGoals.map((goal) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            goal.title,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Target: ${goal.deadline}',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: goal.progress,
                          minHeight: 6,
                          backgroundColor: const Color(0xFFE2E8F0),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            goal.isCompleted
                                ? AppColors.accentGreen
                                : AppColors.primaryBlue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Saved: Rs. ${_formatCurrency(goal.currentAmount)}',
                            style: GoogleFonts.poppins(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            'Goal: Rs. ${_formatCurrency(goal.targetAmount)} (${(goal.progress * 100).toInt()}%)',
                            style: GoogleFonts.poppins(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showNotificationsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notifications',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFECFDF5),
                  child: Icon(
                    Icons.savings_rounded,
                    color: AppColors.accentGreen,
                  ),
                ),
                title: Text(
                  'Goal Update',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Emergency Fund goal completed! Great job saving.',
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFEFF6FF),
                  child: Icon(Icons.bolt_rounded, color: AppColors.primaryBlue),
                ),
                title: Text(
                  'Monthly Budget',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'You have spent 34% on Food & Dining this May.',
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showProfileSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: const Color(0xFFE0E7FF),
                child: Text(
                  widget.userName.isNotEmpty
                      ? widget.userName[0].toUpperCase()
                      : 'H',
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.userName,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Student Member • TechWiz 2026',
                style: GoogleFonts.poppins(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    'Done',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFeaturePlaceholder(String title, String description) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.stars_rounded,
                  color: AppColors.primaryBlue,
                  size: 28,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    'Got It',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
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
}

class _QuickActionData {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final VoidCallback onTap;

  const _QuickActionData({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.onTap,
  });
}

/// Animated waving hand emoji with a natural wrist oscillation curve.
class _WavingHandEmoji extends StatefulWidget {
  const _WavingHandEmoji();

  @override
  State<_WavingHandEmoji> createState() => _WavingHandEmojiState();
}

class _WavingHandEmojiState extends State<_WavingHandEmoji>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    // Natural 3-wave cycle followed by a brief friendly pause
    _rotationAnimation = TweenSequence<double>([
      // Wave 1 left
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: -0.26,
        ).chain(CurveTween(curve: Curves.easeInOutSine)),
        weight: 12,
      ),
      // Wave 1 right
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -0.26,
          end: 0.26,
        ).chain(CurveTween(curve: Curves.easeInOutSine)),
        weight: 14,
      ),
      // Wave 2 left
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.26,
          end: -0.22,
        ).chain(CurveTween(curve: Curves.easeInOutSine)),
        weight: 14,
      ),
      // Wave 2 right
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -0.22,
          end: 0.20,
        ).chain(CurveTween(curve: Curves.easeInOutSine)),
        weight: 14,
      ),
      // Wave 3 back to center
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.20,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInOutSine)),
        weight: 12,
      ),
      // Resting pause
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 34),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value,
          alignment: const Alignment(0.4, 0.8), // Wrist pivot origin
          child: child,
        );
      },
      child: const Text('👋', style: TextStyle(fontSize: 22, height: 1.0)),
    );
  }
}
