import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_assets.dart';
import '../constants/app_colors.dart';

/// Model representing a financial learning lesson in PennyPal.
class LearningTopic {
  final String id;
  final String title;
  final String category;
  final String readTime;
  final String summary;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final List<String> keyPoints;
  final String actionTip;

  const LearningTopic({
    required this.id,
    required this.title,
    required this.category,
    required this.readTime,
    required this.summary,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.keyPoints,
    required this.actionTip,
  });
}

/// Screen 10: Learn & Grow — Student Financial Literacy Hub in PennyPal.
class LearningScreen extends StatefulWidget {
  final bool showBottomNav;

  const LearningScreen({super.key, this.showBottomNav = false});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  final List<String> _filterCategories = [
    'All',
    'Budgeting',
    'Saving',
    'Spending',
    'Income',
  ];

  final List<LearningTopic> _topics = const [
    LearningTopic(
      id: 'TOPIC-1',
      title: 'Budgeting Basics: The 50/30/20 Student Rule',
      category: 'Budgeting',
      readTime: '3 min read',
      summary:
          'Learn how to allocate 50% of your allowance to Needs (books, canteen), 30% to Wants (outings, hobbies), and 20% to Savings.',
      icon: Icons.pie_chart_rounded,
      color: Color(0xFF0077F6),
      bgColor: Color(0xFFEFF6FF),
      keyPoints: [
        '50% Needs: Food, travel, university supplies, and mobile bills.',
        '30% Wants: Weekend hangouts, video games, subscriptions.',
        '20% Savings: Keep untouched in your PennyPal savings wallet.',
      ],
      actionTip: 'Review last week’s canteen spending and see if it stayed under your 50% needs limit.',
    ),
    LearningTopic(
      id: 'TOPIC-2',
      title: 'Needs vs Wants: Stop Impulse Buying',
      category: 'Spending',
      readTime: '2 min read',
      summary:
          'Use the 48-Hour Rule: before making any non-essential purchase over Rs. 1,000, wait 48 hours to see if you still desire it.',
      icon: Icons.compare_arrows_rounded,
      color: Color(0xFF8B5CF6),
      bgColor: Color(0xFFF5F3FF),
      keyPoints: [
        'A Need is something you cannot function at school or home without.',
        'A Want improves lifestyle but is not strictly necessary.',
        'Waiting 48 hours eliminates up to 70% of impulse purchases.',
      ],
      actionTip: 'Next time you browse an online shopping app, save the item to wishlist for 2 days first.',
    ),
    LearningTopic(
      id: 'TOPIC-3',
      title: 'Saving Money on Campus',
      category: 'Saving',
      readTime: '4 min read',
      summary:
          'Practical daily hacks: carrying a water bottle, buying digital or used books, and sharing group rides with classmates.',
      icon: Icons.savings_rounded,
      color: Color(0xFF10B981),
      bgColor: Color(0xFFECFDF5),
      keyPoints: [
        'Group carpooling cuts transport costs in half.',
        'Borrow senior students’ notes instead of printing heavy books.',
        'Track micro-expenses like snacks that add up quickly.',
      ],
      actionTip: 'Set a daily campus cash limit of Rs. 300 to prevent small budget leaks.',
    ),
    LearningTopic(
      id: 'TOPIC-4',
      title: 'Smart Spending & Discounts',
      category: 'Spending',
      readTime: '3 min read',
      summary:
          'Take advantage of student ID discounts on software, food delivery subscriptions, and tech hardware.',
      icon: Icons.local_offer_rounded,
      color: Color(0xFFF59E0B),
      bgColor: Color(0xFFFFFBEB),
      keyPoints: [
        'Always check if student verification grants a 50% discount on software.',
        'Look out for bank cashback promos on utility bills.',
        'Buy durable essentials that last multiple semesters.',
      ],
      actionTip: 'Verify your student email for academic free software packages.',
    ),
    LearningTopic(
      id: 'TOPIC-5',
      title: 'Emergency Savings for Students',
      category: 'Saving',
      readTime: '3 min read',
      summary:
          'Why having Rs. 5,000 to Rs. 10,000 in an emergency buffer prevents panic during sudden laptop repairs or doctor visits.',
      icon: Icons.shield_rounded,
      color: Color(0xFFEF4444),
      bgColor: Color(0xFFFEF2F2),
      keyPoints: [
        'An emergency fund is exclusively for unexpected urgent needs.',
        'Do not use this fund for sales or entertainment.',
        'Build it gradually by putting aside Rs. 500 every week.',
      ],
      actionTip: 'Create a dedicated "Emergency Shield" goal in PennyPal with a target of Rs. 8,000.',
    ),
    LearningTopic(
      id: 'TOPIC-6',
      title: 'Understanding Student Income Sources',
      category: 'Income',
      readTime: '3 min read',
      summary:
          'How to budget variable income from tutoring, graphic design freelancing, or monthly parental support.',
      icon: Icons.account_balance_wallet_rounded,
      color: Color(0xFF0EA5E9),
      bgColor: Color(0xFFF0F9FF),
      keyPoints: [
        'Always budget based on your lowest expected monthly income.',
        'Treat surplus freelance payments as instant savings boosts.',
        'Log income immediately in PennyPal to keep charts accurate.',
      ],
      actionTip: 'Allocate 30% of any freelance earnings straight into your laptop or tuition goal.',
    ),
    LearningTopic(
      id: 'TOPIC-7',
      title: 'Managing Expenses: Spotting Daily Leaks',
      category: 'Spending',
      readTime: '2 min read',
      summary:
          'Discover how daily coffee, rideshare surge pricing, and neglected streaming trials drain your monthly allowance.',
      icon: Icons.search_rounded,
      color: Color(0xFFA855F7),
      bgColor: Color(0xFFFAF5FF),
      keyPoints: [
        'Rs. 150 daily coffee totals over Rs. 4,500 every month.',
        'Audit active auto-renewing subscriptions at the start of each month.',
        'Use PennyPal category charts to spot which category is spiking.',
      ],
      actionTip: 'Cancel unused subscriptions and brew your own beverage 3 days a week.',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<LearningTopic> get _filteredTopics {
    final query = _searchController.text.trim().toLowerCase();
    return _topics.where((t) {
      if (_selectedCategory != 'All' && t.category != _selectedCategory) return false;
      if (query.isNotEmpty) {
        final matchTitle = t.title.toLowerCase().contains(query);
        final matchSum = t.summary.toLowerCase().contains(query);
        if (!matchTitle && !matchSum) return false;
      }
      return true;
    }).toList();
  }

  void _showTopicDetail(LearningTopic topic) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.92,
          expand: false,
          builder: (_, scrollController) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
              child: ListView(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: topic.bgColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          topic.category,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: topic.color,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '• ${topic.readTime}',
                        style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    topic.title,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    topic.summary,
                    style: GoogleFonts.poppins(
                      fontSize: 13.5,
                      color: const Color(0xFF334155),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Key Takeaways',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...topic.keyPoints.map(
                    (point) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: topic.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              point,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: const Color(0xFF475569),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFDCFCE7)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.lightbulb_rounded, color: Color(0xFF10B981), size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Student Action Step',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF047857),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                topic.actionTip,
                                style: GoogleFonts.poppins(
                                  fontSize: 12.5,
                                  color: const Color(0xFF065F46),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 14),
                        _buildSearchBar(),
                        const SizedBox(height: 14),
                        _buildCategoryFilterChips(),
                        const SizedBox(height: 16),
                        _buildHeroBanner(),
                        const SizedBox(height: 18),
                        _buildTopicsList(),
                        const SizedBox(height: 36),
                      ],
                    ),
                  ),
                ),
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
          Image.asset(
            AppAssets.headerLogo,
            height: 32,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Text(
              'PennyPal',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primaryBlue),
            ),
          ),
          const SizedBox(width: 32),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Learn & Grow',
          style: GoogleFonts.poppins(
            fontSize: 23,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          'Bite-sized financial wisdom made for students.',
          style: GoogleFonts.poppins(
            fontSize: 12.5,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textPrimary),
        decoration: InputDecoration(
          icon: const Icon(Icons.search_rounded, color: AppColors.primaryBlue, size: 20),
          hintText: 'Search budgeting tips, savings hacks...',
          hintStyle: GoogleFonts.poppins(fontSize: 12.5, color: const Color(0xFF94A3B8)),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  Widget _buildCategoryFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _filterCategories.map((cat) {
          final isSelected = _selectedCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(cat),
              selected: isSelected,
              labelStyle: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
              selectedColor: AppColors.primaryBlue,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isSelected ? AppColors.primaryBlue : const Color(0xFFE2E8F0),
                ),
              ),
              onSelected: (_) => setState(() => _selectedCategory = cat),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF0077F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withValues(alpha: 0.28),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'TIP OF THE DAY',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Track small daily snacks — they add up to 25% of student allowances.',
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.school_rounded, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicsList() {
    final list = _filteredTopics;
    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: Text(
            'No learning topics match your search.',
            style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Column(
      children: list.map((topic) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: InkWell(
            onTap: () => _showTopicDetail(topic),
            borderRadius: BorderRadius.circular(18),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFEDF3FA)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.035),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: topic.bgColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(topic.icon, color: topic.color, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              topic.category,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: topic.color,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '• ${topic.readTime}',
                              style: GoogleFonts.poppins(fontSize: 10.5, color: const Color(0xFF94A3B8)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          topic.title,
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0F172A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          topic.summary,
                          style: GoogleFonts.poppins(
                            fontSize: 11.5,
                            color: const Color(0xFF64748B),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8), size: 20),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
