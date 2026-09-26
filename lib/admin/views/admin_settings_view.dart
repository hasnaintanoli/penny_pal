import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../services/admin_data_service.dart';

/// Admin App Settings View: Configure application operational parameters,
/// notification triggers, support emails, and legal disclaimers.
class AdminSettingsView extends StatefulWidget {
  const AdminSettingsView({super.key});

  @override
  State<AdminSettingsView> createState() => _AdminSettingsViewState();
}

class _AdminSettingsViewState extends State<AdminSettingsView> {
  late bool _pushEnabled;
  late bool _registrationOpen;
  late bool _autoModerate;
  late TextEditingController _supportEmailController;

  @override
  void initState() {
    super.initState();
    final data = AdminDataService.instance;
    _pushEnabled = data.pushNotificationsEnabled;
    _registrationOpen = data.studentRegistrationOpen;
    _autoModerate = data.autoModerateFeedback;
    _supportEmailController = TextEditingController(text: data.supportEmailAddress);
  }

  @override
  void dispose() {
    _supportEmailController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    AdminDataService.instance.updateAppSettings(
      pushEnabled: _pushEnabled,
      registrationOpen: _registrationOpen,
      autoModerate: _autoModerate,
      supportEmail: _supportEmailController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('PennyPal application settings saved successfully!'),
        backgroundColor: AppColors.accentGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header
          LayoutBuilder(
            builder: (context, headerConstraints) {
              final isWide = headerConstraints.maxWidth >= 650;
              final saveBtn = ElevatedButton.icon(
                onPressed: _saveSettings,
                icon: const Icon(Icons.save_rounded, size: 18),
                label: Text('Save Settings', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
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
                            'Application Settings',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Configure system switches, student registration rules, and support parameters.',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    saveBtn,
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Application Settings',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Configure system switches, student registration rules, and support parameters.',
                      style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    saveBtn,
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 20),

          // 2. Settings Sections (Glass / Clean Cards)
          _buildSettingsSection(
            title: 'Registration & Onboarding',
            icon: Icons.person_add_rounded,
            children: [
              SwitchListTile(
                title: Text('Student Self-Registration', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
                subtitle: Text('Allow new students to create accounts from the mobile app.', style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF64748B))),
                value: _registrationOpen,
                activeTrackColor: AppColors.primaryBlue,
                onChanged: (val) => setState(() => _registrationOpen = val),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildSettingsSection(
            title: 'Notification Controls',
            icon: Icons.notifications_active_rounded,
            children: [
              SwitchListTile(
                title: Text('Push Notifications System', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
                subtitle: Text('Enable automated budget threshold and savings milestone push notifications.', style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF64748B))),
                value: _pushEnabled,
                activeTrackColor: AppColors.primaryBlue,
                onChanged: (val) => setState(() => _pushEnabled = val),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildSettingsSection(
            title: 'Support & Feedback Channel',
            icon: Icons.contact_support_rounded,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  controller: _supportEmailController,
                  decoration: InputDecoration(
                    labelText: 'Official Support Routing Email',
                    hintText: 'support@pennypal.app',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              SwitchListTile(
                title: Text('Auto-Acknowledge Feedback', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
                subtitle: Text('Send a friendly thank-you message when a student submits app feedback.', style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF64748B))),
                value: _autoModerate,
                activeTrackColor: AppColors.primaryBlue,
                onChanged: (val) => setState(() => _autoModerate = val),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildSettingsSection(
            title: 'Legal & Non-Banking Disclaimers',
            icon: Icons.gavel_rounded,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PennyPal is strictly a student personal finance education and expense logging platform. It does NOT operate as a bank, payment processor, digital wallet, or investment advisor.',
                      style: GoogleFonts.poppins(fontSize: 12.5, color: const Color(0xFF475569), height: 1.5),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Application Build: v2.4.0 (Fresh All Along) • Environment: Production',
                        style: GoogleFonts.poppins(fontSize: 11.5, fontWeight: FontWeight.w600, color: const Color(0xFF64748B)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
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
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
            child: Row(
              children: [
                Icon(icon, size: 20, color: AppColors.primaryBlue),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }
}
