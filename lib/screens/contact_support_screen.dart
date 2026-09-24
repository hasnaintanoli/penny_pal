import 'package:flutter/material.dart';

class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  State<ContactSupportScreen> createState() =>
      _ContactSupportScreenState();
}

class _ContactSupportScreenState
    extends State<ContactSupportScreen> {
  final _formKey = GlobalKey<FormState>();

  final messageController = TextEditingController();

  String? selectedSubject;

  final subjects = [
    'Account Problem',
    'Transaction Problem',
    'Budget Problem',
    'Savings Goal',
    'App Bug',
    'Other',
  ];

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void sendMessage() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          icon: const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFF10B981),
            size: 55,
          ),
          title: const Text('Request Sent'),
          content: const Text(
            'Your support request has been submitted successfully. Our team will get back to you soon.',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
              ),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF111827),
          ),
        ),
        title: const Text(
          'Contact Support',
          style: TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _header(),

              const SizedBox(height: 22),

              DropdownButtonFormField<String>(
                value: selectedSubject,
                decoration: InputDecoration(
                  labelText: 'Subject',
                  hintText: 'Select your issue',
                  prefixIcon: const Icon(
                    Icons.subject_rounded,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                    borderSide: const BorderSide(
                      color: Color(0xFFE3ECF5),
                    ),
                  ),
                ),
                items: subjects.map((subject) {
                  return DropdownMenuItem(
                    value: subject,
                    child: Text(subject),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSubject = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a subject';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),

              TextFormField(
                controller: messageController,
                maxLines: 7,
                validator: (value) {
                  if (value == null || value.trim().length < 10) {
                    return 'Please describe your issue';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Message',
                  hintText: 'Describe your issue...',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 95),
                    child: Icon(
                      Icons.chat_outlined,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                    borderSide: const BorderSide(
                      color: Color(0xFFE3ECF5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                    borderSide: const BorderSide(
                      color: Color(0xFF2563EB),
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFFBF7),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFFC7EFE4),
                  ),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: Color(0xFF10B981),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Please provide as much detail as possible so we can help you faster.',
                        style: TextStyle(
                          color: Color(0xFF52756D),
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: FilledButton.icon(
                  onPressed: sendMessage,
                  icon: const Icon(
                    Icons.send_rounded,
                  ),
                  label: const Text(
                    'Send Message',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2563EB),
            Color(0xFF8B5CF6),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.headset_mic_rounded,
            color: Colors.white,
            size: 35,
          ),
          SizedBox(height: 12),
          Text(
            'How Can We Help? 💙',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Tell us about your problem and our team will help you.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}