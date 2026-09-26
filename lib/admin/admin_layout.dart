import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../services/auth_service.dart';
import 'views/admin_dashboard_view.dart';
import 'views/admin_students_view.dart';
import 'views/admin_activity_view.dart';
import 'views/admin_analytics_view.dart';
import 'views/admin_learning_view.dart';
import 'views/admin_support_view.dart';
import 'views/admin_feedback_view.dart';
import 'views/admin_notifications_view.dart';
import 'views/admin_categories_view.dart';
import 'views/admin_settings_view.dart';
import 'views/admin_profile_view.dart';

/// Main Desktop Web Dashboard Shell for PennyPal Administrator Portal.
class AdminLayoutScreen extends StatefulWidget {
  final int initialNavIndex;

  const AdminLayoutScreen({super.key, this.initialNavIndex = 0});

  @override
  State<AdminLayoutScreen> createState() => _AdminLayoutScreenState();
}

class _AdminLayoutScreenState extends State<AdminLayoutScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late int _selectedNavIndex;
  bool _isSidebarCollapsed = false;
  bool _isNotificationDropdownOpen = false;

  final List<String> _navTitles = [
    'Dashboard',
    'Students',
    'Application Activity',
    'Analytics & Reports',
    'Learning Content',
    'Support Queries',
    'Feedback',
    'Notifications',
    'Categories',
    'App Settings',
    'Admin Profile',
  ];

  @override
  void initState() {
    super.initState();
    _selectedNavIndex = widget.initialNavIndex.clamp(0, 10);

    // Role-based security check: Redirect if not authenticated as administrator
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!AuthService.instance.isAdmin) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Access restricted to verified administrators.'),
            backgroundColor: AppColors.error,
          ),
        );
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  void _onSelectNav(int index) {
    setState(() {
      _selectedNavIndex = index;
      _isNotificationDropdownOpen = false;
    });
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF4F7FC),
      drawer: !isDesktop ? _buildSidebar(isDrawer: true) : null,
      body: Row(
        children: [
          // 1. Desktop Left Sidebar
          if (isDesktop) _buildSidebar(isDrawer: false),

          // 2. Main Area (Top Header + View Content)
          Expanded(
            child: Stack(
              children: [
                Column(
                  children: [
                    // Top App Header
                    _buildTopHeader(isDesktop, isTablet),

                    // Active View Content
                    Expanded(
                      child: IndexedStack(
                        index: _selectedNavIndex,
                        children: [
                          AdminDashboardView(onNavigate: _onSelectNav),
                          const AdminStudentsView(),
                          const AdminActivityView(),
                          const AdminAnalyticsView(),
                          const AdminLearningView(),
                          const AdminSupportView(),
                          const AdminFeedbackView(),
                          const AdminNotificationsView(),
                          const AdminCategoriesView(),
                          const AdminSettingsView(),
                          const AdminProfileView(),
                        ],
                      ),
                    ),
                  ],
                ),

                // Notification Dropdown Panel
                if (_isNotificationDropdownOpen)
                  Positioned(
                    top: 65,
                    right: 80,
                    child: _buildNotificationDropdown(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar({required bool isDrawer}) {
    final width = _isSidebarCollapsed && !isDrawer ? 80.0 : 260.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Column(
        children: [
          // Logo & Collapse Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
            ),
            child: Row(
              mainAxisAlignment: _isSidebarCollapsed && !isDrawer
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceBetween,
              children: [
                if (!_isSidebarCollapsed || isDrawer)
                  Image.asset(
                    AppAssets.headerLogo,
                    height: 30,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.account_balance_wallet,
                          color: AppColors.primaryBlue,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'PennyPal',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (!isDrawer)
                  IconButton(
                    icon: Icon(
                      _isSidebarCollapsed
                          ? Icons.chevron_right_rounded
                          : Icons.chevron_left_rounded,
                      color: const Color(0xFF64748B),
                    ),
                    onPressed: () => setState(
                      () => _isSidebarCollapsed = !_isSidebarCollapsed,
                    ),
                  ),
              ],
            ),
          ),

          // Navigation Items List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              children: [
                _buildNavItem(
                  0,
                  'Dashboard',
                  Icons.dashboard_rounded,
                  isDrawer,
                ),
                _buildNavItem(
                  1,
                  'Students',
                  Icons.people_alt_rounded,
                  isDrawer,
                ),
                _buildNavItem(
                  2,
                  'App Activity',
                  Icons.timeline_rounded,
                  isDrawer,
                ),
                _buildNavItem(
                  3,
                  'Analytics & Reports',
                  Icons.insights_rounded,
                  isDrawer,
                ),
                _buildNavItem(
                  4,
                  'Learning Content',
                  Icons.menu_book_rounded,
                  isDrawer,
                ),
                _buildNavItem(
                  5,
                  'Support Queries',
                  Icons.support_agent_rounded,
                  isDrawer,
                ),
                _buildNavItem(
                  6,
                  'Feedback',
                  Icons.rate_review_rounded,
                  isDrawer,
                ),
                _buildNavItem(
                  7,
                  'Notifications',
                  Icons.campaign_rounded,
                  isDrawer,
                ),
                _buildNavItem(
                  8,
                  'Categories',
                  Icons.category_rounded,
                  isDrawer,
                ),
                _buildNavItem(9, 'App Settings', Icons.tune_rounded, isDrawer),
              ],
            ),
          ),

          // Bottom Section: Admin Profile & Logout
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
            ),
            child: Column(
              children: [
                _buildNavItem(
                  10,
                  'Admin Profile',
                  Icons.person_rounded,
                  isDrawer,
                ),
                const SizedBox(height: 4),
                InkWell(
                  onTap: () {
                    AuthService.instance.logout();
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: _isSidebarCollapsed && !isDrawer
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.logout_rounded,
                          size: 20,
                          color: AppColors.error,
                        ),
                        if (!_isSidebarCollapsed || isDrawer) ...[
                          const SizedBox(width: 12),
                          Text(
                            'Logout',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.error,
                            ),
                          ),
                        ],
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

  Widget _buildNavItem(int index, String label, IconData icon, bool isDrawer) {
    final isSelected = _selectedNavIndex == index;
    final isCollapsed = _isSidebarCollapsed && !isDrawer;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: InkWell(
        onTap: () => _onSelectNav(index),
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(
            horizontal: isCollapsed ? 12 : 14,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: isCollapsed
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? Colors.white : const Color(0xFF64748B),
              ),
              if (!isCollapsed) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF334155),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader(bool isDesktop, bool isTablet) {
    final user = AuthService.instance.currentUser;
    final screenWidth = MediaQuery.of(context).size.width;
    final showFullProfile = screenWidth >= 640;

    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 24 : 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          // Mobile Drawer Toggle
          if (!isDesktop) ...[
            IconButton(
              icon: const Icon(Icons.menu_rounded, color: Color(0xFF0F172A)),
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            const SizedBox(width: 8),
          ],

          // Current Page Title
          Expanded(
            child: Text(
              _navTitles[_selectedNavIndex],
              style: GoogleFonts.poppins(
                fontSize: isDesktop ? 17 : 15,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),

          // Notification Bell
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: Color(0xFF64748B),
                  size: 22,
                ),
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
                onPressed: () {
                  setState(
                    () => _isNotificationDropdownOpen =
                        !_isNotificationDropdownOpen,
                  );
                },
              ),
              Positioned(
                top: 4,
                right: 4,
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
          const SizedBox(width: 10),

          // Admin User Profile Chip
          GestureDetector(
            onTap: () => _onSelectNav(10), // Go to Admin Profile
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: showFullProfile ? 10 : 6,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: AppColors.primaryBlue.withValues(
                      alpha: 0.12,
                    ),
                    child: const Icon(
                      Icons.admin_panel_settings_rounded,
                      size: 16,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  if (showFullProfile) ...[
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          user?.name ?? 'Admin Supervisor',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Administrator',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationDropdown() {
    final screenWidth = MediaQuery.of(context).size.width;
    final dropdownWidth = (screenWidth - 32).clamp(280.0, 340.0);

    return Container(
      width: dropdownWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Admin Alerts',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      setState(() => _isNotificationDropdownOpen = false),
                  child: Text(
                    'Close',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          _buildNotificationItem(
            'New Support Query',
            'Ayesha Khan submitted a ticket on PDF exports.',
            Icons.support_agent_rounded,
            const Color(0xFFF59E0B),
          ),
          _buildNotificationItem(
            '5-Star Feedback',
            'Hasnain Ali reviewed the PennyPal budget alerts.',
            Icons.star_rounded,
            const Color(0xFF10B981),
          ),
          _buildNotificationItem(
            'New Registration',
            'Usman Farooq registered from University.',
            Icons.person_add_rounded,
            const Color(0xFF0077F6),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
    String title,
    String desc,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                Text(
                  desc,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
