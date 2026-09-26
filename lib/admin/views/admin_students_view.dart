import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../services/admin_data_service.dart';
import '../utils/admin_date_format.dart';
import '../widgets/admin_confirmation_dialog.dart';
import '../widgets/admin_empty_state.dart';

/// Admin Students Management View: Searchable student directory, status management,
/// and comprehensive student profile & financial summary view.
class AdminStudentsView extends StatefulWidget {
  const AdminStudentsView({super.key});

  @override
  State<AdminStudentsView> createState() => _AdminStudentsViewState();
}

class _AdminStudentsViewState extends State<AdminStudentsView> {
  String _searchQuery = '';
  String _selectedStatusFilter = 'All';
  StudentModel? _selectedStudentForDetails;

  final List<String> _statusOptions = [
    'All',
    'Active',
    'Inactive',
    'Suspended',
  ];

  @override
  Widget build(BuildContext context) {
    if (_selectedStudentForDetails != null) {
      return _buildStudentDetailView(_selectedStudentForDetails!);
    }

    return AnimatedBuilder(
      animation: AdminDataService.instance,
      builder: (context, _) {
        final allStudents = AdminDataService.instance.students;
        final filteredStudents = allStudents.where((s) {
          final matchesSearch =
              s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              s.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              s.mobile.contains(_searchQuery);
          if (_selectedStatusFilter == 'All') return matchesSearch;
          return matchesSearch &&
              s.status.name.toLowerCase() ==
                  _selectedStatusFilter.toLowerCase();
        }).toList();

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width < 600 ? 14.0 : 24.0,
            vertical: 20.0,
          ),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Page Header
              LayoutBuilder(
                builder: (context, headerConstraints) {
                  final isWide = headerConstraints.maxWidth >= 600;
                  final registeredChip = Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBF3FE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.people_alt_rounded,
                          size: 18,
                          color: AppColors.primaryBlue,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${allStudents.length} Registered',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  );

                  if (isWide) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Student Accounts',
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Manage registered PennyPal student accounts and monitor app engagement.',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        registeredChip,
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Student Accounts',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Manage registered PennyPal student accounts and monitor app engagement.',
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 12),
                        registeredChip,
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 20),

              // 2. Search & Filter Bar
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: LayoutBuilder(
                  builder: (context, filterConstraints) {
                    final isWideFilter = filterConstraints.maxWidth >= 700;

                    final searchField = TextField(
                      onChanged: (val) => setState(() => _searchQuery = val),
                      decoration: InputDecoration(
                        hintText: 'Search by student name, email, or mobile...',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 13,
                          color: const Color(0xFF94A3B8),
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: Color(0xFF94A3B8),
                          size: 20,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
                    );

                    final choiceChips = SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _statusOptions.map((status) {
                          final isSelected = _selectedStatusFilter == status;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(
                                status,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF64748B),
                                ),
                              ),
                              selected: isSelected,
                              selectedColor: AppColors.primaryBlue,
                              backgroundColor: const Color(0xFFF1F5F9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              onSelected: (_) => setState(
                                () => _selectedStatusFilter = status,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );

                    if (isWideFilter) {
                      return Row(
                        children: [
                          Expanded(flex: 3, child: searchField),
                          const SizedBox(width: 14),
                          Expanded(flex: 2, child: choiceChips),
                        ],
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          searchField,
                          const SizedBox(height: 12),
                          choiceChips,
                        ],
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),

              // 3. Students Table Card
              Container(
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
                child: filteredStudents.isEmpty
                    ? const AdminEmptyState(
                        icon: Icons.person_search_rounded,
                        title: 'No Students Found',
                        subtitle:
                            'No student accounts match the current search or status filters.',
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(
                              const Color(0xFFF8FAFC),
                            ),
                            horizontalMargin: 20,
                            columnSpacing: 28,
                            headingTextStyle: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF475569),
                            ),
                            dataTextStyle: GoogleFonts.poppins(
                              fontSize: 13,
                              color: const Color(0xFF0F172A),
                            ),
                            columns: const [
                              DataColumn(label: Text('STUDENT')),
                              DataColumn(label: Text('EMAIL')),
                              DataColumn(label: Text('MOBILE')),
                              DataColumn(label: Text('STATUS')),
                              DataColumn(label: Text('REGISTERED')),
                              DataColumn(label: Text('LAST ACTIVITY')),
                              DataColumn(label: Text('ACTIONS')),
                            ],
                            rows: filteredStudents.map((student) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 16,
                                          backgroundColor: const Color(
                                            0xFFE0E7FF,
                                          ),
                                          child: Text(
                                            student.name.isNotEmpty
                                                ? student.name[0].toUpperCase()
                                                : 'S',
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.primaryBlue,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          student.name,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  DataCell(Text(student.email)),
                                  DataCell(Text(student.mobile)),
                                  DataCell(_buildStatusBadge(student.status)),
                                  DataCell(Text(AdminDateFormat.formatShort(student.registeredDate))),
                                  DataCell(Text(AdminDateFormat.formatTime(student.lastActivity))),
                                  DataCell(
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.visibility_outlined,
                                            size: 18,
                                            color: AppColors.primaryBlue,
                                          ),
                                          tooltip: 'View Profile',
                                          onPressed: () {
                                            setState(
                                              () => _selectedStudentForDetails =
                                                  student,
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            student.status ==
                                                    StudentStatus.suspended
                                                ? Icons
                                                      .play_circle_outline_rounded
                                                : Icons
                                                      .pause_circle_outline_rounded,
                                            size: 18,
                                            color:
                                                student.status ==
                                                    StudentStatus.suspended
                                                ? const Color(0xFF10B981)
                                                : const Color(0xFFEF4444),
                                          ),
                                          tooltip:
                                              student.status ==
                                                  StudentStatus.suspended
                                              ? 'Activate Account'
                                              : 'Suspend Account',
                                          onPressed: () =>
                                              _handleToggleStudentStatus(
                                                student,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
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

  Widget _buildStatusBadge(StudentStatus status) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case StudentStatus.active:
        bg = const Color(0xFFECFDF5);
        fg = const Color(0xFF10B981);
        label = 'Active';
        break;
      case StudentStatus.inactive:
        bg = const Color(0xFFF1F5F9);
        fg = const Color(0xFF64748B);
        label = 'Inactive';
        break;
      case StudentStatus.suspended:
        bg = const Color(0xFFFEF2F2);
        fg = const Color(0xFFEF4444);
        label = 'Suspended';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }

  Future<void> _handleToggleStudentStatus(StudentModel student) async {
    final willSuspend = student.status != StudentStatus.suspended;
    final confirmed = await AdminConfirmationDialog.show(
      context,
      title: willSuspend
          ? 'Suspend Student Account?'
          : 'Activate Student Account?',
      message: willSuspend
          ? 'Suspending ${student.name} will restrict their mobile application access until reactivated.'
          : 'Are you sure you want to reactivate ${student.name}\'s student access?',
      confirmLabel: willSuspend ? 'Suspend' : 'Activate',
      isDestructive: willSuspend,
    );

    if (confirmed == true) {
      AdminDataService.instance.setStudentStatus(
        student.id,
        willSuspend ? StudentStatus.suspended : StudentStatus.active,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${student.name} status updated to ${willSuspend ? "Suspended" : "Active"}.',
            ),
            backgroundColor: willSuspend
                ? AppColors.error
                : AppColors.accentGreen,
          ),
        );
      }
    }
  }

  Widget _buildStudentDetailView(StudentModel student) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back Button
          InkWell(
            onTap: () => setState(() => _selectedStudentForDetails = null),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 6.0,
                horizontal: 4.0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.arrow_back_rounded,
                    size: 20,
                    color: AppColors.primaryBlue,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Back to Students Directory',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Profile Header Card
          Container(
            padding: const EdgeInsets.all(20),
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
            child: LayoutBuilder(
              builder: (context, headerConstraints) {
                final isWide = headerConstraints.maxWidth >= 550;

                final avatarWidget = CircleAvatar(
                  radius: 32,
                  backgroundColor: const Color(0xFFE0E7FF),
                  child: Text(
                    student.name.isNotEmpty
                        ? student.name[0].toUpperCase()
                        : 'S',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                );

                final infoColumn = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 10,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          student.name,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        _buildStatusBadge(student.status),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${student.email} • ${student.mobile} • ID: ${student.id}',
                      style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                );

                if (isWide) {
                  return Row(
                    children: [
                      avatarWidget,
                      const SizedBox(width: 18),
                      Expanded(child: infoColumn),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      avatarWidget,
                      const SizedBox(height: 14),
                      infoColumn,
                    ],
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 20),

          // Summary Financial Cards (App-level only)
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 900;
              final isTablet = constraints.maxWidth >= 550 && constraints.maxWidth < 900;

              final card1 = _buildDetailStatBox(
                'App Recorded Balance',
                'Rs. ${student.totalBalanceRecorded.toInt()}',
                const Color(0xFF0077F6),
                Icons.account_balance_wallet_rounded,
              );
              final card2 = _buildDetailStatBox(
                'Total Inflows Logged',
                'Rs. ${student.totalIncomeRecorded.toInt()}',
                const Color(0xFF10B981),
                Icons.arrow_downward_rounded,
              );
              final card3 = _buildDetailStatBox(
                'Total Outflows Logged',
                'Rs. ${student.totalExpenseRecorded.toInt()}',
                const Color(0xFFEF4444),
                Icons.arrow_upward_rounded,
              );
              final card4 = _buildDetailStatBox(
                'Active Budgets & Goals',
                '${student.activeBudgetsCount} Budgets • ${student.activeGoalsCount} Goals',
                const Color(0xFF8B5CF6),
                Icons.track_changes_rounded,
              );

              if (isDesktop) {
                return Row(
                  children: [
                    Expanded(child: card1),
                    const SizedBox(width: 12),
                    Expanded(child: card2),
                    const SizedBox(width: 12),
                    Expanded(child: card3),
                    const SizedBox(width: 12),
                    Expanded(child: card4),
                  ],
                );
              } else if (isTablet) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: card1),
                        const SizedBox(width: 12),
                        Expanded(child: card2),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: card3),
                        const SizedBox(width: 12),
                        Expanded(child: card4),
                      ],
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    card1,
                    const SizedBox(height: 10),
                    card2,
                    const SizedBox(height: 10),
                    card3,
                    const SizedBox(height: 10),
                    card4,
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 20),

          // Important Disclaimer Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 20,
                  color: Color(0xFF64748B),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Application-level financial summaries shown here reflect student self-recorded logs for educational budgeting and are not real banking or payment balances.',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFF64748B),
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

  Widget _buildDetailStatBox(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 11.5,
                    color: const Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}
