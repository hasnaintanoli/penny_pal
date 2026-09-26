import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../services/admin_data_service.dart';

/// Admin Dashboard View: Main overview of platform metrics, student trends,
/// application activity, and system health.
class AdminDashboardView extends StatefulWidget {
  final void Function(int navIndex) onNavigate;

  const AdminDashboardView({
    super.key,
    required this.onNavigate,
  });

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  String _selectedPeriod = '30 Days';
  final List<String> _periodFilters = ['7 Days', '30 Days', '3 Months', '1 Year'];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AdminDataService.instance,
      builder: (context, _) {
        final data = AdminDataService.instance;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width < 600 ? 14.0 : 24.0,
            vertical: 20.0,
          ),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Page Header & Subtitle
              LayoutBuilder(
                builder: (context, headerConstraints) {
                  final isWideHeader = headerConstraints.maxWidth >= 720;
                  final periodPillBar = Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: _periodFilters.map((period) {
                          final isSelected = _selectedPeriod == period;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedPeriod = period),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primaryBlue : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                period,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                  color: isSelected ? Colors.white : const Color(0xFF64748B),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );

                  if (isWideHeader) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dashboard Overview',
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Monitor PennyPal activity, student engagement, and keep the platform organized.',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        periodPillBar,
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dashboard Overview',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Monitor PennyPal activity, student engagement, and keep the platform organized.',
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 14),
                        periodPillBar,
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 20),

              // 2. Top Statistic Cards Grid (6 cards)
              LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final int crossAxisCount;
                  final double childAspectRatio;

                  if (width >= 1100) {
                    crossAxisCount = 6;
                    childAspectRatio = 1.35;
                  } else if (width >= 750) {
                    crossAxisCount = 3;
                    childAspectRatio = 1.45;
                  } else if (width >= 440) {
                    crossAxisCount = 2;
                    childAspectRatio = 1.18;
                  } else {
                    crossAxisCount = 2;
                    childAspectRatio = 1.05;
                  }

                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: childAspectRatio,
                    children: [
                      _buildStatCard(
                        title: 'Total Students',
                        value: '1,248',
                        trend: '+12.4%',
                        isPositive: true,
                        icon: Icons.people_alt_rounded,
                        accentColor: const Color(0xFF0077F6),
                        onTap: () => widget.onNavigate(1), // Students
                      ),
                      _buildStatCard(
                        title: 'Active Students',
                        value: '986',
                        trend: '+8.1%',
                        isPositive: true,
                        icon: Icons.person_pin_circle_rounded,
                        accentColor: const Color(0xFF10B981),
                        onTap: () => widget.onNavigate(1),
                      ),
                      _buildStatCard(
                        title: 'App Transactions',
                        value: '18,540',
                        trend: '+24.5%',
                        isPositive: true,
                        icon: Icons.receipt_long_rounded,
                        accentColor: const Color(0xFF8B5CF6),
                        onTap: () => widget.onNavigate(2), // Activity
                      ),
                      _buildStatCard(
                        title: 'Support Queries',
                        value: '${data.supportQueries.where((q) => q.status == SupportStatus.open).length} Open',
                        trend: '${data.supportQueries.length} Total',
                        isPositive: true,
                        icon: Icons.support_agent_rounded,
                        accentColor: const Color(0xFFF59E0B),
                        onTap: () => widget.onNavigate(5), // Support
                      ),
                      _buildStatCard(
                        title: 'Learning Guides',
                        value: '${data.learningTopics.length}',
                        trend: '4 Categories',
                        isPositive: true,
                        icon: Icons.menu_book_rounded,
                        accentColor: const Color(0xFF06B6D4),
                        onTap: () => widget.onNavigate(4), // Learning
                      ),
                      _buildStatCard(
                        title: 'Savings Goals',
                        value: '2,845',
                        trend: 'Rs. 840k',
                        isPositive: true,
                        icon: Icons.savings_rounded,
                        accentColor: const Color(0xFFEC4899),
                        onTap: () => widget.onNavigate(3), // Analytics
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),

              // 3. Analytics Sections (Side by Side on desktop)
              LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth > 900;

                  if (isDesktop) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left: Student Activity & App Transactions
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              _buildStudentActivityChartCard(),
                              const SizedBox(height: 20),
                              _buildTransactionActivityCard(),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        // Right: Budget Overview & Recent Activity
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              _buildBudgetOverviewCard(),
                              const SizedBox(height: 20),
                              _buildRecentActivityTimelineCard(data.activities),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        _buildStudentActivityChartCard(),
                        const SizedBox(height: 20),
                        _buildTransactionActivityCard(),
                        const SizedBox(height: 20),
                        _buildBudgetOverviewCard(),
                        const SizedBox(height: 20),
                        _buildRecentActivityTimelineCard(data.activities),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String trend,
    required bool isPositive,
    required IconData icon,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: accentColor, size: 18),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      trend,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF10B981),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: const Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentActivityChartCard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 550;

        return Container(
          padding: EdgeInsets.all(isWide ? 20 : 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isWide)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Student Engagement & Growth',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            'Daily active users and registrations recorded in PennyPal',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Row(
                      children: [
                        _buildLegendIndicator('Active', AppColors.primaryBlue),
                        const SizedBox(width: 12),
                        _buildLegendIndicator('Signups', const Color(0xFF10B981)),
                      ],
                    ),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Student Engagement & Growth',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Daily active users and registrations recorded in PennyPal',
                      style: GoogleFonts.poppins(
                        fontSize: 11.5,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _buildLegendIndicator('Active', AppColors.primaryBlue),
                        const SizedBox(width: 12),
                        _buildLegendIndicator('Signups', const Color(0xFF10B981)),
                      ],
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              // Interactive Custom Chart Visualization with equal flex columns
              SizedBox(
                height: 160,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildChartBarColumn('Mon', 0.65, 0.3),
                    _buildChartBarColumn('Tue', 0.78, 0.45),
                    _buildChartBarColumn('Wed', 0.85, 0.5),
                    _buildChartBarColumn('Thu', 0.92, 0.6),
                    _buildChartBarColumn('Fri', 0.74, 0.4),
                    _buildChartBarColumn('Sat', 0.60, 0.25),
                    _buildChartBarColumn('Sun', 0.70, 0.35),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChartBarColumn(String day, double activeRatio, double signupRatio) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 10,
                height: 115 * activeRatio,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF0077F6), Color(0xFF0066EE)],
                  ),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 3),
              Container(
                width: 10,
                height: 115 * signupRatio,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            day,
            style: GoogleFonts.poppins(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendIndicator(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionActivityCard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 600;

        return Container(
          padding: EdgeInsets.all(isWide ? 20 : 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  Text(
                    'Application Expense & Income Records',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Application logs only (Non-banking)',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (isWide)
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricTile(
                        'Total Inflow Logged',
                        'Rs. 4,850,200',
                        const Color(0xFF10B981),
                        Icons.arrow_downward_rounded,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricTile(
                        'Total Outflow Logged',
                        'Rs. 3,120,450',
                        const Color(0xFFEF4444),
                        Icons.arrow_upward_rounded,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricTile(
                        'Net Tracked Savings',
                        'Rs. 1,729,750',
                        const Color(0xFF0077F6),
                        Icons.account_balance_wallet_rounded,
                      ),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    _buildMetricTile(
                      'Total Inflow Logged',
                      'Rs. 4,850,200',
                      const Color(0xFF10B981),
                      Icons.arrow_downward_rounded,
                    ),
                    const SizedBox(height: 10),
                    _buildMetricTile(
                      'Total Outflow Logged',
                      'Rs. 3,120,450',
                      const Color(0xFFEF4444),
                      Icons.arrow_upward_rounded,
                    ),
                    const SizedBox(height: 10),
                    _buildMetricTile(
                      'Net Tracked Savings',
                      'Rs. 1,729,750',
                      const Color(0xFF0077F6),
                      Icons.account_balance_wallet_rounded,
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricTile(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF64748B)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetOverviewCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Budget Limit Health',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 14),
          _buildBudgetProgressRow('Safe Spending (<70%)', 784, 1248, const Color(0xFF10B981)),
          const SizedBox(height: 12),
          _buildBudgetProgressRow('Approaching Limit (70-90%)', 312, 1248, const Color(0xFFF59E0B)),
          const SizedBox(height: 12),
          _buildBudgetProgressRow('Exceeded Limit (>100%)', 152, 1248, const Color(0xFFEF4444)),
        ],
      ),
    );
  }

  Widget _buildBudgetProgressRow(String label, int count, int total, Color color) {
    final ratio = (count / total).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: const Color(0xFF334155)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$count (${(ratio * 100).toInt()}%)',
              style: GoogleFonts.poppins(fontSize: 11.5, fontWeight: FontWeight.w600, color: color),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 8,
            backgroundColor: const Color(0xFFF1F5F9),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivityTimelineCard(List<ActivityItem> activities) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Recent System Activity',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton(
                onPressed: () => widget.onNavigate(2), // View all activity
                child: Text(
                  'View All',
                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryBlue),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...activities.take(4).map((act) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: act.badgeColor.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(act.icon, color: act.badgeColor, size: 16),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          act.title,
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          act.description,
                          style: GoogleFonts.poppins(fontSize: 11.5, color: const Color(0xFF64748B)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${DateTime.now().difference(act.timestamp).inHours > 0 ? "${DateTime.now().difference(act.timestamp).inHours}h" : "${DateTime.now().difference(act.timestamp).inMinutes}m"} ago',
                    style: GoogleFonts.poppins(fontSize: 10.5, color: const Color(0xFF94A3B8)),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
