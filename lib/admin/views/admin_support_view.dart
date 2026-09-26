import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../services/admin_data_service.dart';
import '../utils/admin_date_format.dart';
import '../widgets/admin_empty_state.dart';

/// Admin Support Queries Management: Track student questions, respond to tickets,
/// and update inquiry resolution statuses.
class AdminSupportView extends StatefulWidget {
  const AdminSupportView({super.key});

  @override
  State<AdminSupportView> createState() => _AdminSupportViewState();
}

class _AdminSupportViewState extends State<AdminSupportView> {
  String _selectedFilter = 'All';
  SupportQueryModel? _selectedQuery;
  final TextEditingController _replyController = TextEditingController();

  final List<String> _filterOptions = ['All', 'Open', 'In Progress', 'Resolved'];

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedQuery != null) {
      return _buildQueryDetailView(_selectedQuery!);
    }

    return AnimatedBuilder(
      animation: AdminDataService.instance,
      builder: (context, _) {
        final allQueries = AdminDataService.instance.supportQueries;
        final filtered = allQueries.where((q) {
          if (_selectedFilter == 'All') return true;
          if (_selectedFilter == 'Open') return q.status == SupportStatus.open;
          if (_selectedFilter == 'In Progress') return q.status == SupportStatus.inProgress;
          return q.status == SupportStatus.resolved;
        }).toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header & Summary Badge
              LayoutBuilder(
                builder: (context, headerConstraints) {
                  final isWide = headerConstraints.maxWidth >= 600;
                  final unresolvedBadge = Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.mark_chat_unread_rounded, size: 18, color: Color(0xFFD97706)),
                        const SizedBox(width: 8),
                        Text(
                          '${allQueries.where((q) => q.status == SupportStatus.open).length} Unresolved',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFD97706),
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
                                'Student Support Desk',
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Review student inquiries, troubleshoot issues, and provide timely guidance.',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        unresolvedBadge,
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Student Support Desk',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Review student inquiries, troubleshoot issues, and provide timely guidance.',
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 12),
                        unresolvedBadge,
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 20),

              // 2. Filter Bar
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: _filterOptions.map((filter) {
                    final isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(
                          filter,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected ? Colors.white : const Color(0xFF64748B),
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: AppColors.primaryBlue,
                        backgroundColor: const Color(0xFFF1F5F9),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        onSelected: (_) => setState(() => _selectedFilter = filter),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // 3. Queries Table
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
                child: filtered.isEmpty
                    ? const AdminEmptyState(
                        icon: Icons.support_agent_rounded,
                        title: 'No Queries Found',
                        subtitle: 'No support requests match the selected status category.',
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
                              DataColumn(label: Text('SUBJECT')),
                              DataColumn(label: Text('SUBMITTED')),
                              DataColumn(label: Text('STATUS')),
                              DataColumn(label: Text('LAST UPDATED')),
                              DataColumn(label: Text('ACTION')),
                            ],
                            rows: filtered.map((query) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(query.studentName, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                                        Text(query.studentEmail, style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF64748B))),
                                      ],
                                    ),
                                  ),
                                  DataCell(
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(maxWidth: 260),
                                      child: Text(
                                        query.subject,
                                        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  DataCell(Text(AdminDateFormat.formatTime(query.submittedDate))),
                                  DataCell(_buildStatusBadge(query.status)),
                                  DataCell(Text(AdminDateFormat.formatTime(query.lastUpdated))),
                                  DataCell(
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() => _selectedQuery = query);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primaryBlue,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      child: Text('Respond', style: GoogleFonts.poppins(fontSize: 11.5, fontWeight: FontWeight.w600)),
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

  Widget _buildStatusBadge(SupportStatus status) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case SupportStatus.open:
        bg = const Color(0xFFFEF2F2);
        fg = const Color(0xFFEF4444);
        label = 'Open';
        break;
      case SupportStatus.inProgress:
        bg = const Color(0xFFFFFBEB);
        fg = const Color(0xFFD97706);
        label = 'In Progress';
        break;
      case SupportStatus.resolved:
        bg = const Color(0xFFECFDF5);
        fg = const Color(0xFF10B981);
        label = 'Resolved';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: fg)),
    );
  }

  Widget _buildQueryDetailView(SupportQueryModel query) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back Button
          InkWell(
            onTap: () => setState(() => _selectedQuery = null),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.arrow_back_rounded, size: 20, color: AppColors.primaryBlue),
                  const SizedBox(width: 6),
                  Text(
                    'Back to Support Desk',
                    style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryBlue),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Ticket Info Card
          Container(
            padding: const EdgeInsets.all(22),
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
                  spacing: 10,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    Text(
                      query.subject,
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)),
                    ),
                    _buildStatusBadge(query.status),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Submitted by ${query.studentName} (${query.studentEmail}) on ${AdminDateFormat.formatFull(query.submittedDate)}',
                  style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF64748B)),
                ),
                const Divider(height: 28),

                // Conversation History
                Text('Conversation Thread', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF334155))),
                const SizedBox(height: 12),
                ...query.conversation.map((resp) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: resp.isAdmin ? const Color(0xFFEBF3FE) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: resp.isAdmin ? const Color(0xFFD4E6FA) : const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              resp.sender,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: resp.isAdmin ? AppColors.primaryBlue : const Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              AdminDateFormat.formatTime(resp.time),
                              style: GoogleFonts.poppins(fontSize: 10.5, color: const Color(0xFF94A3B8)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          resp.text,
                          style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF334155), height: 1.4),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 16),

                // Admin Reply Box
                Text('Reply to Student', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF334155))),
                const SizedBox(height: 8),
                TextField(
                  controller: _replyController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Type your official PennyPal support guidance here...',
                    hintStyle: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF94A3B8)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('Update Status:', style: GoogleFonts.poppins(fontSize: 12.5, fontWeight: FontWeight.w600, color: const Color(0xFF475569))),
                        const SizedBox(width: 8),
                        DropdownButton<SupportStatus>(
                          value: query.status,
                          items: const [
                            DropdownMenuItem(value: SupportStatus.open, child: Text('Open')),
                            DropdownMenuItem(value: SupportStatus.inProgress, child: Text('In Progress')),
                            DropdownMenuItem(value: SupportStatus.resolved, child: Text('Resolved')),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => query.status = val);
                              AdminDataService.instance.replyToSupportQuery(query.id, '', val);
                            }
                          },
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_replyController.text.trim().isNotEmpty) {
                          AdminDataService.instance.replyToSupportQuery(
                            query.id,
                            _replyController.text.trim(),
                            SupportStatus.resolved,
                          );
                          _replyController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Response sent and ticket marked Resolved!'),
                              backgroundColor: AppColors.accentGreen,
                            ),
                          );
                          setState(() {});
                        }
                      },
                      icon: const Icon(Icons.send_rounded, size: 16),
                      label: Text('Send Response', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
