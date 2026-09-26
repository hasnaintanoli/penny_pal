import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../services/auth_service.dart';
import '../services/transaction_service.dart';

/// Preset Category configuration with icons, colors, and types.
class CategoryOption {
  final String name;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final bool defaultIsIncome;

  const CategoryOption({
    required this.name,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    this.defaultIsIncome = false,
  });
}

/// Custom painter to draw clean, rounded dashed borders for receipt upload container.
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.2,
    this.dashWidth = 6.0,
    this.dashSpace = 4.0,
    this.borderRadius = 18.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(borderRadius),
    );

    final Path path = Path()..addRRect(rrect);
    final Path dashedPath = Path();

    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double length = (distance + dashWidth < metric.length)
            ? dashWidth
            : metric.length - distance;
        dashedPath.addPath(
          metric.extractPath(distance, distance + length),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }

    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.borderRadius != borderRadius;
  }
}

/// Premium Add Transaction Screen matching the reference design.
/// Features iOS-inspired liquid-glass cards, segmented toggle, category picker,
/// receipt attachment, and seamless integration with PennyPal state management.
class AddTransactionScreen extends StatefulWidget {
  final bool initialIsIncome;

  const AddTransactionScreen({
    super.key,
    this.initialIsIncome = false,
  });

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen>
    with SingleTickerProviderStateMixin {
  late bool _isIncome;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedCategory;
  DateTime _selectedDate = DateTime(2025, 5, 12);
  String? _attachedReceiptName;
  bool _isSaving = false;
  String? _amountError;
  String? _categoryError;

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Available categories list
  static const List<CategoryOption> _categories = [
    CategoryOption(
      name: 'Food & Dining',
      icon: Icons.restaurant_rounded,
      iconColor: Color(0xFFEF4444),
      bgColor: Color(0xFFFEECEC),
    ),
    CategoryOption(
      name: 'Transport',
      icon: Icons.directions_bus_rounded,
      iconColor: Color(0xFF8B5CF6),
      bgColor: Color(0xFFF3E8FF),
    ),
    CategoryOption(
      name: 'Shopping',
      icon: Icons.shopping_bag_rounded,
      iconColor: Color(0xFF0077F6),
      bgColor: Color(0xFFEBF3FE),
    ),
    CategoryOption(
      name: 'Education',
      icon: Icons.school_rounded,
      iconColor: Color(0xFF8B5CF6),
      bgColor: Color(0xFFF3E8FF),
    ),
    CategoryOption(
      name: 'Salary',
      icon: Icons.account_balance_wallet_rounded,
      iconColor: Color(0xFF10B981),
      bgColor: Color(0xFFE8F8F2),
      defaultIsIncome: true,
    ),
    CategoryOption(
      name: 'Freelance Work',
      icon: Icons.work_rounded,
      iconColor: Color(0xFF10B981),
      bgColor: Color(0xFFE8F8F2),
      defaultIsIncome: true,
    ),
    CategoryOption(
      name: 'Bills & Utilities',
      icon: Icons.receipt_long_rounded,
      iconColor: Color(0xFFF59E0B),
      bgColor: Color(0xFFFEF3C7),
    ),
    CategoryOption(
      name: 'Health',
      icon: Icons.favorite_rounded,
      iconColor: Color(0xFFEC4899),
      bgColor: Color(0xFFFCE7F3),
    ),
    CategoryOption(
      name: 'Others',
      icon: Icons.category_rounded,
      iconColor: Color(0xFF64748B),
      bgColor: Color(0xFFF1F5F9),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _isIncome = widget.initialIsIncome;

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  CategoryOption _getCategoryOption(String name) {
    return _categories.firstWhere(
      (cat) => cat.name.toLowerCase() == name.toLowerCase(),
      orElse: () => const CategoryOption(
        name: 'General',
        icon: Icons.attach_money_rounded,
        iconColor: Color(0xFF2563EB),
        bgColor: Color(0xFFEFF6FF),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryBlue,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryBlue,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Category',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () => Navigator.pop(ctx),
                      splashRadius: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.55,
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _categories.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = _selectedCategory == cat.name;

                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedCategory = cat.name;
                            _categoryError = null;
                            if (cat.defaultIsIncome && !_isIncome) {
                              _isIncome = true;
                            }
                          });
                          Navigator.pop(ctx);
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFEFF6FF)
                                : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryBlue
                                  : const Color(0xFFE2E8F0),
                              width: isSelected ? 1.5 : 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: cat.bgColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  cat.icon,
                                  color: cat.iconColor,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  cat.name,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? AppColors.primaryBlue
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: AppColors.primaryBlue,
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showReceiptPickerModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Attach Receipt',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Select a receipt document or sample to attach to this transaction.',
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 18),
                _buildReceiptOptionTile(
                  icon: Icons.camera_alt_rounded,
                  title: 'Take Photo / Scan Receipt',
                  subtitle: 'Use camera to scan paper bill',
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _attachedReceiptName =
                          'Receipt_Scan_${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}.jpg';
                    });
                  },
                ),
                const SizedBox(height: 10),
                _buildReceiptOptionTile(
                  icon: Icons.image_rounded,
                  title: 'Upload from Gallery / Files',
                  subtitle: 'Select PDF or image from device storage',
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _attachedReceiptName =
                          'Receipt_Invoice_${DateTime.now().day}_May.png';
                    });
                  },
                ),
                const SizedBox(height: 10),
                _buildReceiptOptionTile(
                  icon: Icons.receipt_long_rounded,
                  title: 'Attach Sample Merchant Receipt',
                  subtitle: 'Auto-generate verified digital receipt token',
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _attachedReceiptName =
                          '${_selectedCategory ?? "Expense"}_Receipt_Verified.pdf';
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReceiptOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFEBF4FE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primaryBlue, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 11.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF94A3B8),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSaveTransaction() async {
    // 1. Validation
    final amountText = _amountController.text.trim().replaceAll(',', '');
    final double? parsedAmount = double.tryParse(amountText);

    bool hasError = false;
    setState(() {
      _amountError = null;
      _categoryError = null;
    });

    if (parsedAmount == null || parsedAmount <= 0) {
      setState(() {
        _amountError = 'Please enter a valid amount greater than 0';
      });
      hasError = true;
    }

    if (_selectedCategory == null || _selectedCategory!.isEmpty) {
      setState(() {
        _categoryError = 'Please choose a category';
      });
      hasError = true;
    }

    if (hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill in all required fields.',
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.white),
          ),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    // 2. Saving state & feedback
    setState(() {
      _isSaving = true;
    });

    await Future.delayed(const Duration(milliseconds: 400));

    final catOption = _getCategoryOption(_selectedCategory!);
    final description = _descriptionController.text.trim().isNotEmpty
        ? _descriptionController.text.trim()
        : catOption.name;

    final newTxn = TransactionItem(
      id: 'TXN-${DateTime.now().millisecondsSinceEpoch}',
      category: catOption.name,
      description: description,
      dateOrTime: _formatDate(_selectedDate),
      amount: parsedAmount!,
      isIncome: _isIncome,
      transactionType: _isIncome ? 'income' : 'expense',
      icon: catOption.icon,
      iconColor: catOption.iconColor,
      iconBgColor: catOption.bgColor,
      receiptName: _attachedReceiptName,
      dateTime: _selectedDate,
    );

    // 3. Save to centralized TransactionService (and Firestore if logged in)
    TransactionService.instance.addTransaction(
      newTxn,
      userId: AuthService.instance.currentUser?.id,
    );

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Transaction of Rs. ${parsedAmount.toStringAsFixed(parsedAmount.truncateToDouble() == parsedAmount ? 0 : 2)} saved!',
                style: GoogleFonts.poppins(fontSize: 13, color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );

    // Return to Transactions Screen
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8FE),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    // Top App Bar
                    _buildTopAppBar(),

                    // Scrollable content
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header Title & Illustration
                            _buildHeaderSection(),
                            const SizedBox(height: 18),

                            // Segmented Toggle (Income / Expense)
                            _buildIncomeExpenseSegmentedControl(),
                            const SizedBox(height: 18),

                            // Form Fields
                            _buildAmountCard(),
                            const SizedBox(height: 14),

                            _buildCategoryCard(),
                            const SizedBox(height: 14),

                            _buildDateCard(),
                            const SizedBox(height: 14),

                            _buildDescriptionCard(),
                            const SizedBox(height: 16),

                            // Attach Receipt Box
                            _buildAttachReceiptBox(),
                            const SizedBox(height: 24),

                            // Save Button
                            _buildSaveButton(),
                            const SizedBox(height: 36),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 1. TOP APP BAR
  // ==========================================
  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Back button
          InkWell(
            onTap: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).pushReplacementNamed('/transactions');
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(6),
              child: const Icon(
                Icons.arrow_back_rounded,
                size: 24,
                color: Color(0xFF0F172A),
              ),
            ),
          ),

          // Center: Official PennyPal Header Logo
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

          // Right: Search & Notification Icons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  child: const Icon(
                    Icons.search_rounded,
                    size: 22,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(
                        Icons.notifications_none_rounded,
                        size: 23,
                        color: Color(0xFF0F172A),
                      ),
                      Positioned(
                        top: 1,
                        right: 2,
                        child: Container(
                          width: 7,
                          height: 7,
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

  // ==========================================
  // 2. HEADER TITLE & WALLET ASSET
  // ==========================================
  Widget _buildHeaderSection() {
    return SizedBox(
      height: 105,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background soft cloud/hill shapes behind wallet
          Positioned(
            right: 15,
            top: 5,
            child: Container(
              width: 85,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFDCEAFE).withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Positioned(
            right: 48,
            top: 22,
            child: Container(
              width: 65,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2FE).withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          // Left: Main Title & Subtitle
          Positioned(
            left: 0,
            top: 16,
            right: 130,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add Transaction',
                  style: GoogleFonts.poppins(
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Keep track of your spending',
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),

          // Right: Exact Provided 3D Wallet Illustration Asset
          Positioned(
            right: -4,
            top: -6,
            bottom: 0,
            child: Image.asset(
              AppAssets.addTransactionWallet,
              width: 145,
              fit: BoxFit.contain,
              alignment: Alignment.centerRight,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(width: 120);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 3. INCOME & EXPENSE SEGMENTED CONTROL
  // ==========================================
  Widget _buildIncomeExpenseSegmentedControl() {
    return Container(
      height: 56,
      padding: const EdgeInsets.all(4.5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.95),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0066EE).withValues(alpha: 0.09),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Income Option
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (!_isIncome) {
                  setState(() {
                    _isIncome = true;
                  });
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: _isIncome
                      ? const LinearGradient(
                          colors: [Color(0xFF2676FD), Color(0xFF1660F8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  boxShadow: _isIncome
                      ? [
                          BoxShadow(
                            color: const Color(0xFF1660F8).withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 3.5),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: _isIncome
                            ? Colors.white
                            : const Color(0xFF64748B).withValues(alpha: 0.16),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_downward_rounded,
                        size: 17,
                        color: _isIncome
                            ? const Color(0xFF1660F8)
                            : const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Income',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight:
                            _isIncome ? FontWeight.w600 : FontWeight.w500,
                        color: _isIncome
                            ? Colors.white
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Expense Option
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (_isIncome) {
                  setState(() {
                    _isIncome = false;
                  });
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: !_isIncome
                      ? const LinearGradient(
                          colors: [Color(0xFF2676FD), Color(0xFF1660F8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  boxShadow: !_isIncome
                      ? [
                          BoxShadow(
                            color: const Color(0xFF1660F8).withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 3.5),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: !_isIncome
                            ? Colors.white
                            : const Color(0xFF64748B).withValues(alpha: 0.16),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_upward_rounded,
                        size: 17,
                        color: !_isIncome
                            ? const Color(0xFF1660F8)
                            : const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Expense',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight:
                            !_isIncome ? FontWeight.w600 : FontWeight.w500,
                        color: !_isIncome
                            ? Colors.white
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 4. AMOUNT CARD
  // ==========================================
  Widget _buildAmountCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _amountError != null
              ? const Color(0xFFEF4444)
              : const Color(0xFFEDF3FA),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.035),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Badge: Soft light blue squircle with blue "Rs" badge
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFDCEAFE),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Container(
                width: 26,
                height: 26,
                decoration: const BoxDecoration(
                  color: Color(0xFF1E64EB),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    'Rs',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Right Content: Label & Input field
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Amount',
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FBFE),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Rs. ',
                        style: GoogleFonts.poppins(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          style: GoogleFonts.poppins(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0F172A),
                          ),
                          decoration: InputDecoration(
                            hintText: '0.00',
                            hintStyle: GoogleFonts.poppins(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF94A3B8),
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onChanged: (_) {
                            if (_amountError != null) {
                              setState(() {
                                _amountError = null;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                if (_amountError != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    _amountError!,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: const Color(0xFFEF4444),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 5. CATEGORY CARD
  // ==========================================
  Widget _buildCategoryCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _categoryError != null
              ? const Color(0xFFEF4444)
              : const Color(0xFFEDF3FA),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.035),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Badge: Squircle with 4-square grid icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFDCEAFE),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Icon(
                Icons.grid_view_rounded,
                color: Color(0xFF1E64EB),
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Right Content: Label & Category Selector
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Category',
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: _showCategoryPicker,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FBFE),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedCategory ?? 'Select Category',
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            fontWeight: _selectedCategory != null
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: _selectedCategory != null
                                ? const Color(0xFF0F172A)
                                : const Color(0xFF94A3B8),
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 20,
                          color: Color(0xFF94A3B8),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_categoryError != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    _categoryError!,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: const Color(0xFFEF4444),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 6. DATE CARD
  // ==========================================
  Widget _buildDateCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEDF3FA), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.035),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Badge: Squircle with calendar icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFDCEAFE),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Icon(
                Icons.calendar_today_rounded,
                color: Color(0xFF1E64EB),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Right Content: Label & Date Picker Field
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Date',
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FBFE),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDate(_selectedDate),
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        const Icon(
                          Icons.calendar_month_outlined,
                          size: 19,
                          color: Color(0xFF94A3B8),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 7. DESCRIPTION CARD
  // ==========================================
  Widget _buildDescriptionCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEDF3FA), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.035),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Badge: Squircle with note icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFDCEAFE),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Icon(
                Icons.description_rounded,
                color: Color(0xFF1E64EB),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Right Content: Label & Multiline Input Field
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Description (Optional)',
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FBFE),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: TextField(
                    controller: _descriptionController,
                    maxLines: 2,
                    style: GoogleFonts.poppins(
                      fontSize: 13.5,
                      color: const Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Add a note...',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 13,
                        color: const Color(0xFF94A3B8),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 8. ATTACH RECEIPT BOX (Dashed Border)
  // ==========================================
  Widget _buildAttachReceiptBox() {
    final hasReceipt = _attachedReceiptName != null;

    return CustomPaint(
      painter: DashedBorderPainter(
        color: hasReceipt
            ? const Color(0xFF2563EB)
            : const Color(0xFFBFDBFE),
        strokeWidth: 1.3,
        dashWidth: 6,
        dashSpace: 4,
        borderRadius: 20,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        decoration: BoxDecoration(
          color: hasReceipt
              ? const Color(0xFFEFF6FF).withValues(alpha: 0.7)
              : const Color(0xFFF4F9FF).withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(20),
        ),
        child: hasReceipt
            ? Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCEAFE),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.receipt_long_rounded,
                        color: Color(0xFF1E64EB),
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _attachedReceiptName!,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0F172A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Receipt attached • Tap to replace',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: const Color(0xFF10B981),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Color(0xFFEF4444),
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _attachedReceiptName = null;
                      });
                    },
                    tooltip: 'Remove Receipt',
                  ),
                ],
              )
            : InkWell(
                onTap: _showReceiptPickerModal,
                borderRadius: BorderRadius.circular(20),
                child: Row(
                  children: [
                    // Squircle icon container with camera + plus icon
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCEAFE),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.add_a_photo_rounded,
                          color: Color(0xFF1E64EB),
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Attach Receipt (Optional)',
                            style: GoogleFonts.poppins(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Tap to upload image',
                            style: GoogleFonts.poppins(
                              fontSize: 11.5,
                              color: const Color(0xFF64748B),
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
  }

  // ==========================================
  // 9. SAVE TRANSACTION BUTTON
  // ==========================================
  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF2676FD), Color(0xFF1660F8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1660F8).withValues(alpha: 0.38),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isSaving ? null : _handleSaveTransaction,
          borderRadius: BorderRadius.circular(28),
          child: Center(
            child: _isSaving
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.save_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Save Transaction',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
