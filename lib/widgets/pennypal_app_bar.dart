import 'package:flutter/material.dart';

class PennyPalAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PennyPalAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(82);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 82,
      titleSpacing: 20,
      title: Row(
        children: [
          Image.asset(
            'assets/images/pennypal_logo.png',
            height: 52,
            width: 52,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: 'Penny',
                      style: TextStyle(
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    TextSpan(
                      text: 'Pal',
                      style: TextStyle(
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                'Fresh All Along',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF6B84A5),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.notifications_none_rounded,
                    color: Color(0xFF203A5F),
                    size: 25,
                  ),
                ),
                Positioned(
                  right: 9,
                  top: 8,
                  child: Container(
                    height: 8,
                    width: 8,
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Simple clean container - No detector, no extra brackets
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFE0F2FE),
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Color(0xFF2563EB),
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
