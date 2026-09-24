import 'package:flutter/material.dart';
import 'more_screen.dart';
import '../widgets/pennypal_app_bar.dart';
import '../widgets/pennypal_bottom_nav.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  void changeTab(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: const PennyPalAppBar(),

      body: _buildBody(),

      bottomNavigationBar: PennyPalBottomNav(
        currentIndex: currentIndex,
        onTap: changeTab,
      ),
    );
  }

  Widget _buildBody() {
    if (currentIndex == 4) {
      return const MoreScreen();
    }

    if (currentIndex != 0) {
      return Center(
        child: Text(
          _placeholderTitle(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
      );
    }

    return const _HomeContent();
  }

  String _placeholderTitle() {
    if (currentIndex == 1) {
      return 'Transactions';
    }

    if (currentIndex == 2) {
      return 'Budgets';
    }

    return 'Goals';
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Good morning, Student! 👋',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Small steps today, big dreams tomorrow.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B84A5),
            ),
          ),

          const SizedBox(height: 18),

          const _BalanceCard(),

          const SizedBox(height: 22),

          const _QuickActions(),

          const SizedBox(height: 22),

          const _SpendingCard(),

          const SizedBox(height: 20),

          const _SavingsCard(),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2563EB),
            Color(0xFF3182E8),
            Color(0xFF28A9D6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Total Balance',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.visibility_outlined,
                color: Colors.white,
                size: 19,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'May 2025',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          const Text(
            'Rs. 12,450',
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 22),

          Row(
            children: [
              Expanded(
                child: _moneyInfo(
                  icon: Icons.arrow_upward_rounded,
                  title: 'Income',
                  amount: 'Rs. 18,000',
                  color: const Color(0xFF10B981),
                ),
              ),

              Container(
                height: 45,
                width: 1,
                color: Colors.white.withOpacity(0.3),
              ),

              Expanded(
                child: _moneyInfo(
                  icon: Icons.arrow_downward_rounded,
                  title: 'Expenses',
                  amount: 'Rs. 5,550',
                  color: const Color(0xFFFF647C),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _moneyInfo({
    required IconData icon,
    required String title,
    required String amount,
    required Color color,
  }) {
    return Row(
      children: [
        const SizedBox(width: 8),

        Container(
          height: 34,
          width: 34,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),

        const SizedBox(width: 10),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              amount,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    final actions = [
      (
      Icons.add_rounded,
      'Add\nTransaction',
      const Color(0xFF10B981),
      ),
      (
      Icons.pie_chart_rounded,
      'Set\nBudget',
      const Color(0xFF2563EB),
      ),
      (
      Icons.track_changes_rounded,
      'Savings\nGoals',
      const Color(0xFF8B5CF6),
      ),
      (
      Icons.menu_book_rounded,
      'Learn',
      const Color(0xFFF59E0B),
      ),
      (
      Icons.smart_toy_outlined,
      'AI\nAssistant',
      const Color(0xFF13B8D4),
      ),
    ];

    return SizedBox(
      height: 112,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final action = actions[index];

          return SizedBox(
            width: 72,
            child: Column(
              children: [
                Container(
                  height: 60,
                  width: 72,
                  decoration: BoxDecoration(
                    color: action.$3.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: action.$3.withOpacity(0.08),
                    ),
                  ),
                  child: Center(
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: action.$3,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(
                        action.$1,
                        color: Colors.white,
                        size: 23,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  action.$2,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF203A5F),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SpendingCard extends StatelessWidget {
  const _SpendingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE3ECF5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Spending',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'This month • Rs. 5,550',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF7692B5),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF526D8D),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              SizedBox(
                height: 135,
                width: 135,
                child: CustomPaint(
                  painter: _SpendingPainter(),
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Rs. 5,550',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF7692B5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 15),

              const Expanded(
                child: Column(
                  children: [
                    _CategoryRow(
                      color: Color(0xFF2563EB),
                      title: 'Food & Dining',
                      percent: '34%',
                    ),
                    _CategoryRow(
                      color: Color(0xFF10B981),
                      title: 'Transport',
                      percent: '22%',
                    ),
                    _CategoryRow(
                      color: Color(0xFF8B5CF6),
                      title: 'Shopping',
                      percent: '18%',
                    ),
                    _CategoryRow(
                      color: Color(0xFFF59E0B),
                      title: 'Education',
                      percent: '14%',
                    ),
                    _CategoryRow(
                      color: Color(0xFF8AA6C2),
                      title: 'Others',
                      percent: '12%',
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
}

class _CategoryRow extends StatelessWidget {
  final Color color;
  final String title;
  final String percent;

  const _CategoryRow({
    required this.color,
    required this.title,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF526D8D),
              ),
            ),
          ),
          Text(
            percent,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF203A5F),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpendingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius = size.width / 2 - 10;

    final values = [34.0, 22.0, 18.0, 14.0, 12.0];

    final colors = [
      const Color(0xFF2563EB),
      const Color(0xFF10B981),
      const Color(0xFF8B5CF6),
      const Color(0xFFF59E0B),
      const Color(0xFF8AA6C2),
    ];

    double startAngle = -1.5708;

    for (int i = 0; i < values.length; i++) {
      final sweepAngle = (values[i] / 100) * 6.28318;

      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 20;

      canvas.drawArc(
        Rect.fromCircle(
          center: center,
          radius: radius,
        ),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _SavingsCard extends StatelessWidget {
  const _SavingsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FBF8),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFC7EFE4),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.track_changes_rounded,
                  color: Color(0xFF10B981),
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Savings Goals',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Keep going! You’re doing great!',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF6B84A5),
                      ),
                    ),
                  ],
                ),
              ),

              const Text(
                '1 of 3 goals',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF6B84A5),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(17),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F1FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.laptop_mac_rounded,
                        color: Color(0xFF2563EB),
                      ),
                    ),

                    const SizedBox(width: 10),

                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'New Laptop',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF203A5F),
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Rs. 25,000 / Rs. 60,000',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF7692B5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: const LinearProgressIndicator(
                    value: 0.42,
                    minHeight: 9,
                    backgroundColor: Color(0xFFE8EEF5),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF10B981),
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '42%',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6B84A5),
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
}