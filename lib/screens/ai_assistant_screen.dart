import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

/// Screen 11: AI Financial Assistant for PennyPal.
/// Provides friendly, interactive student financial guidance and advice.
class AIAssistantScreen extends StatefulWidget {
  final bool showBottomNav;

  const AIAssistantScreen({super.key, this.showBottomNav = false});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  final List<ChatMessage> _messages = [
    ChatMessage(
      text:
          "Hi Hasnain! 👋 I'm PennyPal Assistant. I'm here to help you build smart budgeting habits, save for your goals, and answer student finance questions.",
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];

  final List<String> _suggestedPrompts = [
    'How can I save more money?',
    'How should I create a budget?',
    'Why am I spending too much?',
    'How can I reach my savings goal?',
  ];

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final userMsg = ChatMessage(
      text: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMsg);
      _isTyping = true;
    });

    _inputController.clear();
    _scrollToBottom();

    // Generate intelligent educational financial response
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      final responseText = _generateAIResponse(text);
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(
          text: responseText,
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _generateAIResponse(String prompt) {
    final lower = prompt.toLowerCase();
    if (lower.contains('save') || lower.contains('saving')) {
      return "💡 Here are 3 student savings rules:\n\n1. **The 24-Hour Wait**: Delay non-essential purchases for 24 hours.\n2. **Split Allowances**: Move 20% to your PennyPal savings goal as soon as you receive it.\n3. **Campus Hacks**: Share group rides and buy used academic books.";
    } else if (lower.contains('budget')) {
      return "📊 Try the **50/30/20 Student Framework**:\n\n• **50% Needs**: Canteen meals, public transit, exam stationery.\n• **30% Wants**: Weekend cafes, gaming, outings.\n• **20% Savings**: Emergency buffer & tech gadget fund.\n\nYou can set monthly category limits on your PennyPal Budgets tab!";
    } else if (lower.contains('spending') || lower.contains('too much') || lower.contains('why')) {
      return "🔍 Frequent spending leaks for students usually come from:\n\n• Daily takeaway drinks or delivery fees.\n• Unchecked automatic app subscriptions.\n• Peer pressure during group hangouts.\n\nTip: Review your recent transaction list in PennyPal to pinpoint your highest category this week!";
    } else if (lower.contains('goal') || lower.contains('laptop') || lower.contains('reach')) {
      return "🎯 To reach your savings goal faster:\n\n1. Calculate the monthly contribution on our **Create Goal** screen.\n2. Deposit small daily wins (e.g. Rs. 200 saved on lunch).\n3. Keep the target date realistic so you stay motivated without stress!";
    } else {
      return "I'm always here to guide your money habits! As a student, the key to financial freedom is tracking every transaction, planning monthly budgets, and avoiding unneeded debt.\n\nAsk me about budgeting rules, saving strategies, or goal planning!";
    }
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
                _buildDisclaimerBanner(),
                Expanded(child: _buildChatList()),
                if (_isTyping) _buildTypingIndicator(),
                _buildSuggestedChips(),
                _buildMessageInput(),
                const SizedBox(height: 12),
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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2563EB), Color(0xFF0077F6)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'PennyPal Assistant',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    'Financial literacy guide',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 32),
        ],
      ),
    );
  }

  Widget _buildDisclaimerBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFDBEAFE)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: AppColors.primaryBlue, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'PennyPal Assistant provides educational money tips, not official banking advice.',
              style: GoogleFonts.poppins(fontSize: 10.5, color: const Color(0xFF1E40AF)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final msg = _messages[index];
        return Align(
          alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.78,
            ),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: msg.isUser ? const Color(0xFF2563EB) : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: Radius.circular(msg.isUser ? 18 : 4),
                bottomRight: Radius.circular(msg.isUser ? 4 : 18),
              ),
              boxShadow: [
                BoxShadow(
                  color: msg.isUser
                      ? const Color(0xFF2563EB).withValues(alpha: 0.25)
                      : const Color(0xFF0F172A).withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment:
                  msg.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  msg.text,
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    color: msg.isUser ? Colors.white : const Color(0xFF0F172A),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${msg.timestamp.hour.toString().padLeft(2, '0')}:${msg.timestamp.minute.toString().padLeft(2, '0')}',
                  style: GoogleFonts.poppins(
                    fontSize: 9.5,
                    color: msg.isUser ? Colors.white70 : const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryBlue),
                ),
                const SizedBox(width: 8),
                Text(
                  'PennyPal is thinking...',
                  style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Row(
        children: _suggestedPrompts.map((prompt) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ActionChip(
              label: Text(prompt),
              labelStyle: GoogleFonts.poppins(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryBlue,
              ),
              backgroundColor: const Color(0xFFEFF6FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: Color(0xFFDBEAFE)),
              ),
              onPressed: () => _sendMessage(prompt),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _inputController,
              textCapitalization: TextCapitalization.sentences,
              style: GoogleFonts.poppins(fontSize: 13.5, color: const Color(0xFF0F172A)),
              decoration: InputDecoration(
                hintText: 'Ask anything about budgeting & saving...',
                hintStyle: GoogleFonts.poppins(fontSize: 12.5, color: const Color(0xFF94A3B8)),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              ),
              onSubmitted: _sendMessage,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send_rounded, color: AppColors.primaryBlue, size: 22),
            onPressed: () => _sendMessage(_inputController.text),
          ),
        ],
      ),
    );
  }
}
