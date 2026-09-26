import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_assets.dart';
import '../constants/app_colors.dart';

/// Screen for creating and calculating new savings goals in PennyPal.
class CreateGoalScreen extends StatefulWidget {
  const CreateGoalScreen({super.key});

  @override
  State<CreateGoalScreen> createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends State<CreateGoalScreen> {
  final TextEditingController _goalNameController = TextEditingController();
  final TextEditingController _targetAmountController = TextEditingController();
  final TextEditingController _currentSavingsController = TextEditingController();
  final TextEditingController _monthlyContributionController = TextEditingController();

  String _selectedCategory = 'Gadgets & Tech';
  DateTime _selectedDate = DateTime(2025, 12, 31);
  bool _isSaving = false;

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Gadgets & Tech',
      'icon': Icons.laptop_mac_rounded,
      'color': const Color(0xFF0077F6),
      'bg': const Color(0xFFEFF6FF),
    },
    {
      'name': 'Travel & Trips',
      'icon': Icons.flight_takeoff_rounded,
      'color': const Color(0xFF8B5CF6),
      'bg': const Color(0xFFF5F3FF),
    },
    {
      'name': 'Education',
      'icon': Icons.school_rounded,
      'color': const Color(0xFF10B981),
      'bg': const Color(0xFFECFDF5),
    },
    {
      'name': 'Vehicle / Car Fund',
      'icon': Icons.directions_car_rounded,
      'color': const Color(0xFFF59E0B),
      'bg': const Color(0xFFFFFBEB),
    },
    {
      'name': 'Emergency Fund',
      'icon': Icons.shield_rounded,
      'color': const Color(0xFFEF4444),
      'bg': const Color(0xFFFEF2F2),
    },
    {
      'name': 'Personal Milestone',
      'icon': Icons.star_rounded,
      'color': const Color(0xFF0EA5E9),
      'bg': const Color(0xFFF0F9FF),
    },
  ];

  @override
  void dispose() {
    _goalNameController.dispose();
    _targetAmountController.dispose();
    _currentSavingsController.dispose();
    _monthlyContributionController.dispose();
    super.dispose();
  }

  double get _targetAmount =>
      double.tryParse(_targetAmountController.text.replaceAll(',', '')) ?? 0.0;
  double get _currentSavings =>
      double.tryParse(_currentSavingsController.text.replaceAll(',', '')) ?? 0.0;
  double get _monthlyContribution =>
      double.tryParse(_monthlyContributionController.text.replaceAll(',', '')) ?? 0.0;

  double get _remainingAmount =>
      (_targetAmount - _currentSavings).clamp(0.0, double.infinity);

  double get _progressPercent {
    if (_targetAmount <= 0) return 0.0;
    return (_currentSavings / _targetAmount).clamp(0.0, 1.0);
  }

  String get _estimatedCompletionMonths {
    if (_remainingAmount <= 0) return 'Goal already reached!';
    if (_monthlyContribution <= 0) return 'Set monthly contribution to estimate';
    final months = (_remainingAmount / _monthlyContribution).ceil();
    return '$months month${months == 1 ? '' : 's'} to target (${(_selectedDate.month)}/${_selectedDate.year})';
  }

  String _formatCurrency(num amount) {
    final intVal = amount.toInt();
    final str = intVal.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) buffer.write(',');
    }
    return buffer.toString().split('').reversed.join('');
  }

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryBlue,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _handleCreateGoal() async {
    if (_goalNameController.text.trim().isEmpty) {
      _showSnackbar('Please enter a goal name', isError: true);
      return;
    }
    if (_targetAmount <= 0) {
      _showSnackbar('Please enter a valid target amount', isError: true);
      return;
    }

    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _isSaving = false);

    _showSnackbar('Savings Goal "${_goalNameController.text.trim()}" created successfully!');
    Navigator.of(context).pop(true);
  }

  void _showSnackbar(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.poppins(fontSize: 13, color: Colors.white)),
        backgroundColor: isError ? const Color(0xFFEF4444) : const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
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
            child: Column(
              children: [
                _buildTopAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeaderSection(),
                        const SizedBox(height: 16),
                        _buildLiveCalculatedCard(),
                        const SizedBox(height: 18),
                        _buildGoalNameCard(),
                        const SizedBox(height: 14),
                        _buildCategoryCard(),
                        const SizedBox(height: 14),
                        _buildTargetAmountCard(),
                        const SizedBox(height: 14),
                        _buildCurrentSavingsCard(),
                        const SizedBox(height: 14),
                        _buildTargetDateCard(),
                        const SizedBox(height: 14),
                        _buildMonthlyContributionCard(),
                        const SizedBox(height: 24),
                        _buildCreateGoalButton(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => Navigator.of(context).pop(),
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
          Image.asset(
            AppAssets.headerLogo,
            height: 32,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Text(
              'PennyPal',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryBlue,
              ),
            ),
          ),
          const SizedBox(width: 32),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create Savings Goal',
          style: GoogleFonts.poppins(
            fontSize: 23,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          'Set a target and track your milestone progress.',
          style: GoogleFonts.poppins(
            fontSize: 12.5,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildLiveCalculatedCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0077F6), Color(0xFF0055D4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0066EE).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Live Goal Summary',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${(_progressPercent * 100).toStringAsFixed(0)}% Saved',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: _progressPercent,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.25),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Remaining',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  Text(
                    'Rs. ${_formatCurrency(_remainingAmount)}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Target Goal',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  Text(
                    'Rs. ${_formatCurrency(_targetAmount)}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, size: 16, color: Colors.white),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _estimatedCompletionMonths,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
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

  Widget _buildGoalNameCard() {
    return _buildCardWrapper(
      icon: Icons.flag_rounded,
      label: 'Goal Name',
      child: TextField(
        controller: _goalNameController,
        style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: 'e.g. New MacBook / Exam Fees / Trip',
          hintStyle: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF94A3B8)),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildCategoryCard() {
    return _buildCardWrapper(
      icon: Icons.category_rounded,
      label: 'Category',
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF94A3B8)),
          items: _categories.map((cat) {
            return DropdownMenuItem<String>(
              value: cat['name'] as String,
              child: Row(
                children: [
                  Icon(cat['icon'] as IconData, size: 18, color: cat['color'] as Color),
                  const SizedBox(width: 8),
                  Text(
                    cat['name'] as String,
                    style: GoogleFonts.poppins(fontSize: 13.5, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) setState(() => _selectedCategory = val);
          },
        ),
      ),
    );
  }

  Widget _buildTargetAmountCard() {
    return _buildCardWrapper(
      icon: Icons.savings_rounded,
      label: 'Target Amount',
      child: Row(
        children: [
          Text(
            'Rs. ',
            style: GoogleFonts.poppins(fontSize: 14.5, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A)),
          ),
          Expanded(
            child: TextField(
              controller: _targetAmountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: GoogleFonts.poppins(fontSize: 14.5, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A)),
              decoration: InputDecoration(
                hintText: '50,000',
                hintStyle: GoogleFonts.poppins(fontSize: 14.5, color: const Color(0xFF94A3B8)),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentSavingsCard() {
    return _buildCardWrapper(
      icon: Icons.account_balance_wallet_rounded,
      label: 'Current Savings',
      child: Row(
        children: [
          Text(
            'Rs. ',
            style: GoogleFonts.poppins(fontSize: 14.5, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A)),
          ),
          Expanded(
            child: TextField(
              controller: _currentSavingsController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: GoogleFonts.poppins(fontSize: 14.5, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A)),
              decoration: InputDecoration(
                hintText: '0.00',
                hintStyle: GoogleFonts.poppins(fontSize: 14.5, color: const Color(0xFF94A3B8)),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetDateCard() {
    return _buildCardWrapper(
      icon: Icons.calendar_today_rounded,
      label: 'Target Date',
      child: InkWell(
        onTap: _pickDate,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formatDate(_selectedDate),
              style: GoogleFonts.poppins(fontSize: 13.5, fontWeight: FontWeight.w500, color: const Color(0xFF0F172A)),
            ),
            const Icon(Icons.calendar_month_outlined, size: 19, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyContributionCard() {
    return _buildCardWrapper(
      icon: Icons.trending_up_rounded,
      label: 'Monthly Contribution (Optional)',
      child: Row(
        children: [
          Text(
            'Rs. ',
            style: GoogleFonts.poppins(fontSize: 14.5, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A)),
          ),
          Expanded(
            child: TextField(
              controller: _monthlyContributionController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: GoogleFonts.poppins(fontSize: 14.5, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A)),
              decoration: InputDecoration(
                hintText: '5,000 / month',
                hintStyle: GoogleFonts.poppins(fontSize: 14.5, color: const Color(0xFF94A3B8)),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardWrapper({
    required IconData icon,
    required String label,
    required Widget child,
  }) {
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
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFDCEAFE),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Icon(icon, color: AppColors.primaryBlue, size: 21),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
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
                  child: Center(child: child),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateGoalButton() {
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
          onTap: _isSaving ? null : _handleCreateGoal,
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
                      const Icon(Icons.add_task_rounded, color: Colors.white, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'Create Goal',
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
