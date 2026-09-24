import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final commentsController = TextEditingController();

  int selectedRating = 0;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    commentsController.dispose();
    super.dispose();
  }

  String ratingText() {
    switch (selectedRating) {
      case 1:
        return 'We will try to do better 💙';
      case 2:
        return 'Thanks for your honest feedback';
      case 3:
        return 'Glad you shared your thoughts';
      case 4:
        return 'Great! We are happy you like it';
      case 5:
        return 'Amazing! Thank you ⭐';
      default:
        return 'Tap a star to rate PennyPal';
    }
  }

  void submitFeedback() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a rating.'),
        ),
      );
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
          title: const Text('Thank You! 💙'),
          content: const Text(
            'Your feedback has been received. Thank you for helping us improve PennyPal.',
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
          'Feedback',
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

              _textField(
                controller: nameController,
                label: 'Your Name',
                hint: 'Enter your name',
                icon: Icons.person_outline_rounded,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              _textField(
                controller: emailController,
                label: 'Email Address',
                hint: 'example@email.com',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }

                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 22),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'How would you rate PennyPal?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                      (index) {
                    final rating = index + 1;

                    return IconButton(
                      onPressed: () {
                        setState(() {
                          selectedRating = rating;
                        });
                      },
                      icon: AnimatedScale(
                        scale: selectedRating == rating ? 1.18 : 1,
                        duration: const Duration(milliseconds: 180),
                        child: Icon(
                          rating <= selectedRating
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: const Color(0xFFF59E0B),
                          size: 42,
                        ),
                      ),
                    );
                  },
                ),
              ),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Text(
                  ratingText(),
                  key: ValueKey(selectedRating),
                  style: const TextStyle(
                    color: Color(0xFF6B84A5),
                    fontSize: 13,
                  ),
                ),
              ),

              const SizedBox(height: 22),

              _textField(
                controller: commentsController,
                label: 'Your Feedback',
                hint: 'Tell us what you think...',
                icon: Icons.chat_bubble_outline_rounded,
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().length < 5) {
                    return 'Please enter some feedback';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 25),

              _submitButton(
                text: 'Submit Feedback',
                icon: Icons.send_rounded,
                onPressed: submitFeedback,
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
            Color(0xFF35A8E0),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.rate_review_rounded,
            color: Colors.white,
            size: 35,
          ),
          SizedBox(height: 12),
          Text(
            'We Value Your Feedback 💙',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Help us make PennyPal better for you.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
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
    );
  }

  Widget _submitButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(
          text,
          style: const TextStyle(
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
    );
  }
}