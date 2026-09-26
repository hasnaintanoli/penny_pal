import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../services/admin_data_service.dart';
import '../utils/admin_date_format.dart';
import '../widgets/admin_empty_state.dart';

/// Admin Feedback View: Student ratings, reviews, and satisfaction monitoring.
class AdminFeedbackView extends StatefulWidget {
  const AdminFeedbackView({super.key});

  @override
  State<AdminFeedbackView> createState() => _AdminFeedbackViewState();
}

class _AdminFeedbackViewState extends State<AdminFeedbackView> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AdminDataService.instance,
      builder: (context, _) {
        final feedbackList = AdminDataService.instance.feedbackList;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Student Feedback & Ratings',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Direct testimonials, feature requests, and usability reviews from students.',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 2. Summary Metric Cards (Responsive Grid)
              LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final int crossAxisCount;
                  final double childAspectRatio;

                  if (width >= 900) {
                    crossAxisCount = 4;
                    childAspectRatio = 1.35;
                  } else if (width >= 500) {
                    crossAxisCount = 2;
                    childAspectRatio = 1.4;
                  } else {
                    crossAxisCount = 2;
                    childAspectRatio = 1.15;
                  }

                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: childAspectRatio,
                    children: [
                      _buildMetricCard('Total Reviews', '${feedbackList.length + 339}', Icons.rate_review_rounded, const Color(0xFF0077F6)),
                      _buildMetricCard('Average Rating', '4.8 / 5.0', Icons.star_rounded, const Color(0xFFF59E0B)),
                      _buildMetricCard('5-Star Reviews', '289 (84%)', Icons.thumb_up_rounded, const Color(0xFF10B981)),
                      _buildMetricCard(
                        'Pending Review',
                        '${feedbackList.where((f) => f.status == FeedbackStatus.pending).length}',
                        Icons.pending_actions_rounded,
                        const Color(0xFF8B5CF6),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),

              // 3. Feedback Reviews Table
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
                child: feedbackList.isEmpty
                    ? const AdminEmptyState(
                        icon: Icons.star_outline_rounded,
                        title: 'No Feedback Recorded',
                        subtitle: 'No student reviews available yet.',
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                            horizontalMargin: 20,
                            columnSpacing: 28,
                            headingTextStyle: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF475569),
                            ),
                            dataTextStyle: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF0F172A)),
                            columns: const [
                              DataColumn(label: Text('STUDENT')),
                              DataColumn(label: Text('RATING')),
                              DataColumn(label: Text('COMMENT / REVIEW')),
                              DataColumn(label: Text('DATE')),
                              DataColumn(label: Text('STATUS')),
                              DataColumn(label: Text('ACTION')),
                            ],
                            rows: feedbackList.map((fdb) {
                              final isPending = fdb.status == FeedbackStatus.pending;
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(fdb.studentName, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                                        Text(fdb.studentEmail, style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF64748B))),
                                      ],
                                    ),
                                  ),
                                  DataCell(
                                    Row(
                                      children: List.generate(
                                        5,
                                        (i) => Icon(
                                          i < fdb.rating ? Icons.star_rounded : Icons.star_border_rounded,
                                          size: 16,
                                          color: const Color(0xFFF59E0B),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(maxWidth: 320),
                                      child: Text(
                                        fdb.comment,
                                        style: GoogleFonts.poppins(fontSize: 12.5),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  DataCell(Text(AdminDateFormat.formatShort(fdb.date))),
                                  DataCell(
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: isPending ? const Color(0xFFFFFBEB) : const Color(0xFFECFDF5),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        isPending ? 'Pending' : 'Reviewed',
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: isPending ? const Color(0xFFD97706) : const Color(0xFF10B981),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    isPending
                                        ? TextButton(
                                            onPressed: () {
                                              AdminDataService.instance.markFeedbackReviewed(fdb.id);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Feedback marked as Reviewed.'),
                                                  backgroundColor: AppColors.accentGreen,
                                                ),
                                              );
                                            },
                                            child: Text('Mark Reviewed', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryBlue)),
                                          )
                                        : const Icon(Icons.check_rounded, color: Color(0xFF10B981), size: 18),
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

  Widget _buildMetricCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 11.5, color: const Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}
