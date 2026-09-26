import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../services/admin_data_service.dart';
import '../utils/admin_date_format.dart';
import '../widgets/admin_confirmation_dialog.dart';
import '../widgets/admin_empty_state.dart';

/// Admin Notifications View: Broadcast notification campaigns to students.
class AdminNotificationsView extends StatefulWidget {
  const AdminNotificationsView({super.key});

  @override
  State<AdminNotificationsView> createState() => _AdminNotificationsViewState();
}

class _AdminNotificationsViewState extends State<AdminNotificationsView> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AdminDataService.instance,
      builder: (context, _) {
        final notifications = AdminDataService.instance.notifications;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header & Create Button
              LayoutBuilder(
                builder: (context, headerConstraints) {
                  final isWide = headerConstraints.maxWidth >= 650;
                  final createButton = ElevatedButton.icon(
                    onPressed: _openCreateNotificationModal,
                    icon: const Icon(Icons.campaign_rounded, size: 18),
                    label: Text(
                      'Create Notification',
                      style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                                'Push Notification Campaigns',
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Broadcast savings reminders, budget alerts, and new learning guide announcements.',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        createButton,
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Push Notification Campaigns',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Broadcast savings reminders, budget alerts, and new learning guide announcements.',
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 12),
                        createButton,
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 20),

              // 2. Notifications Table Card
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
                child: notifications.isEmpty
                    ? const AdminEmptyState(
                        icon: Icons.notifications_none_rounded,
                        title: 'No Notifications Created',
                        subtitle: 'Create a notification to send financial tips or budget updates to students.',
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
                              DataColumn(label: Text('CAMPAIGN TITLE & MESSAGE')),
                              DataColumn(label: Text('TYPE')),
                              DataColumn(label: Text('TARGET AUDIENCE')),
                              DataColumn(label: Text('SCHEDULED / SENT')),
                              DataColumn(label: Text('STATUS')),
                              DataColumn(label: Text('RECIPIENTS')),
                            ],
                            rows: notifications.map((notif) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(maxWidth: 320),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(notif.title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                                          Text(
                                            notif.message,
                                            style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF64748B)),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  DataCell(_buildTypeBadge(notif.type)),
                                  DataCell(Text(notif.audience)),
                                  DataCell(Text(AdminDateFormat.formatShort(notif.scheduledDate))),
                                  DataCell(_buildStatusBadge(notif.status)),
                                  DataCell(Text('${notif.recipientsCount} students')),
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

  Widget _buildTypeBadge(NotificationType type) {
    Color color;
    String label;

    switch (type) {
      case NotificationType.budgetAlert:
        color = const Color(0xFFEF4444);
        label = 'Budget Alert';
        break;
      case NotificationType.savingsReminder:
        color = const Color(0xFF8B5CF6);
        label = 'Savings Reminder';
        break;
      case NotificationType.learningTip:
        color = const Color(0xFF0077F6);
        label = 'Learning Tip';
        break;
      case NotificationType.systemNotification:
        color = const Color(0xFF10B981);
        label = 'System';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
    );
  }

  Widget _buildStatusBadge(NotificationStatus status) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case NotificationStatus.sent:
        bg = const Color(0xFFECFDF5);
        fg = const Color(0xFF10B981);
        label = 'Sent';
        break;
      case NotificationStatus.scheduled:
        bg = const Color(0xFFFFFBEB);
        fg = const Color(0xFFD97706);
        label = 'Scheduled';
        break;
      case NotificationStatus.draft:
        bg = const Color(0xFFF1F5F9);
        fg = const Color(0xFF64748B);
        label = 'Draft';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: fg)),
    );
  }

  void _openCreateNotificationModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const _CreateNotificationDialog(),
    );
  }
}

class _CreateNotificationDialog extends StatefulWidget {
  const _CreateNotificationDialog();

  @override
  State<_CreateNotificationDialog> createState() => _CreateNotificationDialogState();
}

class _CreateNotificationDialogState extends State<_CreateNotificationDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  NotificationType _selectedType = NotificationType.learningTip;
  String _selectedAudience = 'All Students';

  final List<String> _audienceOptions = ['All Students', 'Active Students', 'Budget Overspenders'];

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _handleSend() async {
    if (_titleController.text.trim().isEmpty || _messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide title and message content.'), backgroundColor: AppColors.error),
      );
      return;
    }

    final confirmed = await AdminConfirmationDialog.show(
      context,
      title: 'Broadcast Notification?',
      message: 'Are you sure you want to broadcast "${_titleController.text}" to $_selectedAudience?',
      confirmLabel: 'Broadcast Now',
    );

    if (confirmed == true && mounted) {
      final newCampaign = NotificationCampaignModel(
        id: 'NOTIF-${DateTime.now().millisecondsSinceEpoch % 10000}',
        title: _titleController.text.trim(),
        message: _messageController.text.trim(),
        type: _selectedType,
        audience: _selectedAudience,
        scheduledDate: DateTime.now(),
        status: NotificationStatus.sent,
        recipientsCount: _selectedAudience == 'All Students' ? 1248 : 986,
      );

      AdminDataService.instance.addNotificationCampaign(newCampaign);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Push notification broadcasted to students!'),
          backgroundColor: AppColors.accentGreen,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Create Push Notification',
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(height: 20),
              Text('Notification Title', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF334155))),
              const SizedBox(height: 6),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'e.g., Weekly Savings Milestone Achieved!',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 14),

              Text('Message Content', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF334155))),
              const SizedBox(height: 6),
              TextField(
                controller: _messageController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Type message body for student notification banners...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Notification Type', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF334155))),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<NotificationType>(
                          initialValue: _selectedType,
                          items: const [
                            DropdownMenuItem(value: NotificationType.budgetAlert, child: Text('Budget Alert')),
                            DropdownMenuItem(value: NotificationType.savingsReminder, child: Text('Savings Reminder')),
                            DropdownMenuItem(value: NotificationType.learningTip, child: Text('Learning Tip')),
                            DropdownMenuItem(value: NotificationType.systemNotification, child: Text('System Alert')),
                          ],
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedType = val);
                          },
                          decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Target Audience', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF334155))),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedAudience,
                          items: _audienceOptions.map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedAudience = val);
                          },
                          decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel', style: GoogleFonts.poppins(color: const Color(0xFF64748B))),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _handleSend,
                    icon: const Icon(Icons.send_rounded, size: 16),
                    label: Text('Broadcast Notification', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
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
      ),
    );
  }
}
