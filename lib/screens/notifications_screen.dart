import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_assets.dart';
import '../constants/app_colors.dart';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String category;
  final String timeAgo;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.category,
    required this.timeAgo,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    this.isRead = false,
  });
}

/// Screen 12: Notifications Center for PennyPal.
class NotificationsScreen extends StatefulWidget {
  final bool showBottomNav;

  const NotificationsScreen({super.key, this.showBottomNav = false});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Budgets', 'Goals', 'Tips', 'Alerts'];

  late List<NotificationItem> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = [
      NotificationItem(
        id: 'NOTIF-1',
        title: 'Budget Alert: Food & Dining',
        message: 'Your Food budget is almost reached (Rs. 8,500 of Rs. 12,000 used).',
        category: 'Budgets',
        timeAgo: '15m ago',
        icon: Icons.warning_amber_rounded,
        iconColor: const Color(0xFFEF4444),
        iconBg: const Color(0xFFFEF2F2),
        isRead: false,
      ),
      NotificationItem(
        id: 'NOTIF-2',
        title: 'Goal Milestone Achieved! 🎉',
        message: 'You saved Rs. 5,000 toward your New Laptop Goal! You are now at 42%.',
        category: 'Goals',
        timeAgo: '2h ago',
        icon: Icons.check_circle_rounded,
        iconColor: const Color(0xFF10B981),
        iconBg: const Color(0xFFECFDF5),
        isRead: false,
      ),
      NotificationItem(
        id: 'NOTIF-3',
        title: 'Monthly Budget Summary',
        message: 'Your monthly budget has 20% remaining (Rs. 17,500 available for May).',
        category: 'Budgets',
        timeAgo: '1d ago',
        icon: Icons.pie_chart_rounded,
        iconColor: const Color(0xFF0077F6),
        iconBg: const Color(0xFFEFF6FF),
        isRead: true,
      ),
      NotificationItem(
        id: 'NOTIF-4',
        title: 'New Financial Learning Tip',
        message: 'Learn how the 50/30/20 rule helps students manage campus allowances.',
        category: 'Tips',
        timeAgo: '2d ago',
        icon: Icons.school_rounded,
        iconColor: const Color(0xFF8B5CF6),
        iconBg: const Color(0xFFF5F3FF),
        isRead: true,
      ),
      NotificationItem(
        id: 'NOTIF-5',
        title: 'Security Notice',
        message: 'Your PennyPal session was renewed securely.',
        category: 'Alerts',
        timeAgo: '3d ago',
        icon: Icons.security_rounded,
        iconColor: const Color(0xFF64748B),
        iconBg: const Color(0xFFF1F5F9),
        isRead: true,
      ),
    ];
  }

  List<NotificationItem> get _filteredList {
    if (_selectedFilter == 'All') return _notifications;
    return _notifications.where((n) => n.category == _selectedFilter).toList();
  }

  void _markAllAsRead() {
    setState(() {
      for (var n in _notifications) {
        n.isRead = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All notifications marked as read', style: GoogleFonts.poppins(fontSize: 12.5)),
        backgroundColor: AppColors.primaryBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                        const SizedBox(height: 14),
                        _buildFilterChips(),
                        const SizedBox(height: 16),
                        _buildNotificationList(),
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
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(6),
              child: const Icon(Icons.arrow_back_rounded, size: 24, color: Color(0xFF0F172A)),
            ),
          ),
          Image.asset(
            AppAssets.headerLogo,
            height: 32,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Text(
              'PennyPal',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primaryBlue),
            ),
          ),
          TextButton(
            onPressed: _markAllAsRead,
            child: Text(
              'Mark Read',
              style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryBlue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notifications',
          style: GoogleFonts.poppins(
            fontSize: 23,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          'Stay updated on budgets, goals and savings tips.',
          style: GoogleFonts.poppins(
            fontSize: 12.5,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _filters.map((f) {
          final isSelected = _selectedFilter == f;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(f),
              selected: isSelected,
              labelStyle: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
              selectedColor: AppColors.primaryBlue,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isSelected ? AppColors.primaryBlue : const Color(0xFFE2E8F0),
                ),
              ),
              onSelected: (_) => setState(() => _selectedFilter = f),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNotificationList() {
    final list = _filteredList;
    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: Text(
            'No notifications in this category.',
            style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Column(
      children: list.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: item.isRead ? Colors.white : const Color(0xFFF0F7FF),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: item.isRead ? const Color(0xFFEDF3FA) : const Color(0xFFBFDBFE),
              width: item.isRead ? 1.0 : 1.3,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: item.iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, color: item.iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: GoogleFonts.poppins(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                        Text(
                          item.timeAgo,
                          style: GoogleFonts.poppins(fontSize: 10.5, color: const Color(0xFF94A3B8)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.message,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFF475569),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
