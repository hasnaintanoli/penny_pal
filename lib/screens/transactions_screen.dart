import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../widgets/liquid_glass_bottom_nav_bar.dart';

/// Model representing an individual transaction record in PennyPal.
class TransactionItem {
  final String id;
  final String category;
  final String description;
  final String dateOrTime;
  final double amount;
  final bool isIncome;
  final String transactionType; // 'all', 'income', 'expense', 'transfer'
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;

  const TransactionItem({
    required this.id,
    required this.category,
    required this.description,
    required this.dateOrTime,
    required this.amount,
    required this.isIncome,
    this.transactionType = 'expense',
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
  });
}

/// PennyPal Transactions Screen displaying detailed transaction history,
/// interactive category filters, search, and the decorative Total Balance card.
class TransactionsScreen extends StatefulWidget {
  final bool showBottomNav;

  const TransactionsScreen({super.key, this.showBottomNav = true});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final TextEditingController _searchController = TextEditingController();

  bool _isBalanceVisible = true;
  bool _isSearching = false;
  String _selectedMonth = 'May 2025';
  String _selectedFilterTab = 'All';
  int _selectedNavIndex = 1; // Transactions is active (index 1)

  final List<String> _filterTabs = ['All', 'Income', 'Expenses', 'Transfers'];

  final List<String> _availableMonths = [
    'May 2025',
    'April 2025',
    'March 2025',
    'February 2025',
    'January 2025',
  ];

  late final Query _dbRef;

  @override
  void initState() {
    super.initState();
    _dbRef = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://pennypal-de604-default-rtdb.firebaseio.com',
    ).ref().child('transactions');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  TransactionItem _mapFirebaseSnapshotToItem(String key, Map val) {
    final String category = val['category'] ?? 'Others';
    final bool isIncome = val['isIncome'] == true || val['type'] == 'Income';

    IconData icon = Icons.payments_rounded;
    Color iconColor = AppColors.primaryBlue;
    Color iconBgColor = const Color(0xFFEBF3FE);

    if (category.contains('Food')) {
      icon = Icons.restaurant_rounded;
      iconColor = const Color(0xFFEF4444);
      iconBgColor = const Color(0xFFFEECEC);
    } else if (category.contains('Freelance') ||
        category.contains('Work') ||
        category.contains('Salary')) {
      icon = Icons.work_rounded;
      iconColor = const Color(0xFF10B981);
      iconBgColor = const Color(0xFFE8F8F2);
    } else if (category.contains('Transport')) {
      icon = Icons.directions_bus_rounded;
      iconColor = const Color(0xFF8B5CF6);
      iconBgColor = const Color(0xFFF3E8FF);
    } else if (category.contains('Shopping')) {
      icon = Icons.shopping_bag_rounded;
      iconColor = const Color(0xFF0077F6);
      iconBgColor = const Color(0xFFEBF3FE);
    } else if (category.contains('Education')) {
      icon = Icons.school_rounded;
      iconColor = const Color(0xFF8B5CF6);
      iconBgColor = const Color(0xFFF3E8FF);
    }

    return TransactionItem(
      id: key,
      category: category,
      description: val['description'] ?? category,
      dateOrTime: val['dateOrTime'] ?? 'Today',
      amount: (val['amount'] ?? 0.0).toDouble(),
      isIncome: isIncome,
      transactionType: val['transactionType'] ??
          (isIncome ? 'income' : 'expense'),
      icon: icon,
      iconColor: iconColor,
      iconBgColor: iconBgColor,
    );
  }

  String _formatCurrency(num amount) {
    final intVal = amount.toInt();
    final str = intVal.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write(',');
      }
    }
    return buffer
        .toString()
        .split('')
        .reversed
        .join('');
  }

  void _showFilterOptionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter Transactions',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: _filterTabs.map((tab) {
                  final isSelected = _selectedFilterTab == tab;
                  return ChoiceChip(
                    label: Text(tab),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedFilterTab = tab;
                        });
                        Navigator.pop(context);
                      }
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
      stream: _dbRef.onValue,
      builder: (context, snapshot) {
        double liveTotalIncome = 0.0;
        double liveTotalExpenses = 0.0;
        List<TransactionItem> liveFilteredList = [];

        if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
          final rawDataMap =
          snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

          rawDataMap.forEach((key, val) {
            if (val is Map) {
              final parsedItem =
              _mapFirebaseSnapshotToItem(key.toString(), val);

              if (parsedItem.isIncome) {
                liveTotalIncome += parsedItem.amount;
              } else {
                liveTotalExpenses += parsedItem.amount;
              }

              bool passesTab = true;
              if (_selectedFilterTab == 'Income' && !parsedItem.isIncome) {
                passesTab = false;
              }
              if (_selectedFilterTab == 'Expenses' && parsedItem.isIncome) {
                passesTab = false;
              }
              if (_selectedFilterTab == 'Transfers' &&
                  parsedItem.transactionType != 'transfer') {
                passesTab = false;
              }

              bool passesSearch = true;
              final query = _searchController.text.trim().toLowerCase();
              if (query.isNotEmpty) {
                final inCat = parsedItem.category.toLowerCase().contains(query);
                final inDesc =
                parsedItem.description.toLowerCase().contains(query);
                final inAmt = parsedItem.amount.toString().contains(query);
                if (!inCat && !inDesc && !inAmt) passesSearch = false;
              }

              if (passesTab && passesSearch) {
                liveFilteredList.add(parsedItem);
              }
            }
          });

          liveFilteredList.sort((a, b) => b.id.compareTo(a.id));
        }

        double liveTotalBalance = liveTotalIncome - liveTotalExpenses;

        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: SafeArea(
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  children: [
                    _buildTopNavigationHeader(),
                    if (_isSearching) ...[
                      _buildInlineSearchBar(),
                    ],
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 6.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildScreenTitleSection(),
                            const SizedBox(height: 16),
                            _buildTotalBalanceCard(
                              totalBalance: liveTotalBalance,
                              totalIncome: liveTotalIncome,
                              totalExpenses: liveTotalExpenses,
                            ),
                            const SizedBox(height: 18),
                            _buildFilterTabs(),
                            const SizedBox(height: 18),
                            _buildDateSectionHeader(),
                            const SizedBox(height: 12),
                            _buildTransactionsList(liveFilteredList, _dbRef),
                            SizedBox(height: widget.showBottomNav ? 24 : 85),
                          ],
                        ),
                      ),
                    ),
                    if (widget.showBottomNav) _buildBottomNavigationBar(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopNavigationHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: const BoxDecoration(color: Color(0xFFF5F7FA)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).pushReplacementNamed('/home');
              }
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.all(6),
              child: const Icon(
                Icons.arrow_back_rounded,
                size: 24,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 8),
                Image.asset(
                  AppAssets.headerLogo,
                  height: 32,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.account_balance_wallet,
                          color: AppColors.primaryBlue,
                          size: 22,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'PennyPal',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _isSearching = !_isSearching;
                    if (!_isSearching) {
                      _searchController.clear();
                    }
                  });
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    _isSearching ? Icons.close_rounded : Icons.search_rounded,
                    size: 24,
                    color: _isSearching
                        ? AppColors.primaryBlue
                        : AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: _showFilterOptionsBottomSheet,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  child: const Icon(
                    Icons.tune_rounded,
                    size: 24,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInlineSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textPrimary),
        decoration: InputDecoration(
          icon: const Icon(
            Icons.search_rounded,
            color: AppColors.primaryBlue,
            size: 20,
          ),
          hintText: 'Search by category, merchant, amount...',
          hintStyle: GoogleFonts.poppins(
            fontSize: 12.5,
            color: AppColors.textSecondary,
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
        onChanged: (_) {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildScreenTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transactions',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Track your money, build better habits.',
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalBalanceCard({
    required double totalBalance,
    required double totalIncome,
    required double totalExpenses,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0077F6), Color(0xFF0066EE), Color(0xFF0A58CA)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0066EE).withValues(alpha: 0.28),
            offset: const Offset(0, 8),
            blurRadius: 20,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Total Balance',
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isBalanceVisible = !_isBalanceVisible;
                        });
                      },
                      child: Icon(
                        _isBalanceVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 18,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 28,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedMonth,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      dropdownColor: const Color(0xFF0066EE),
                      style: GoogleFonts.poppins(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      items: _availableMonths.map((month) {
                        return DropdownMenuItem<String>(
                          value: month,
                          child: Text(
                            month,
                            style: GoogleFonts.poppins(
                              fontSize: 11.5,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        if (newVal != null) {
                          setState(() {
                            _selectedMonth = newVal;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              _isBalanceVisible
                  ? 'Rs. ${_formatCurrency(totalBalance)}'
                  : '••••••••',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_upward_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Income',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                          Text(
                            _isBalanceVisible
                                ? 'Rs. ${_formatCurrency(totalIncome)}'
                                : '••••••',
                            style: GoogleFonts.poppins(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 28,
                  color: Colors.white.withValues(alpha: 0.25),
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEF4444),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_downward_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Expenses',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                          Text(
                            _isBalanceVisible
                                ? 'Rs. ${_formatCurrency(totalExpenses)}'
                                : '••••••',
                            style: GoogleFonts.poppins(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _filterTabs.map((tab) {
          final isSelected = _selectedFilterTab == tab;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(tab),
              selected: isSelected,
              selectedColor: AppColors.primaryBlue,
              labelStyle: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected
                      ? AppColors.primaryBlue
                      : const Color(0xFFE2E8F0),
                ),
              ),
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedFilterTab = tab;
                  });
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDateSectionHeader() {
    return Text(
      'Recent Transactions',
      style: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

// =========================================================================
// UPDATED TRANSACTIONS LIST WITH INLINE EDIT & DELETE ACTIONS
// =========================================================================
  Widget _buildTransactionsList(List<TransactionItem> items,
      dynamic dbRef) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Text(
            'No transactions found.',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF1F5F9)),
          ),
          child: Row(
            children: [
// Icon Indicator Token
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: item.iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, color: item.iconColor, size: 22),
              ),
              const SizedBox(width: 12),

// Title Description Column Label details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.category,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${item.description} • ${item.dateOrTime}',
                      style: GoogleFonts.poppins(
                        fontSize: 11.5,
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

// 🟢 Actions Group Row: Value Text + Edit Icon Button + Delete Icon Button
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
// 1. Numerical Cash Amount text display
                  Text(
                    '${item.isIncome ? '+' : '-'} Rs. ${_formatCurrency(
                        item.amount)}',
                    style: GoogleFonts.poppins(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: item.isIncome
                          ? const Color(0xFF10B981)
                          : const Color(0xFFEF4444),
                    ),
                  ),
                  const SizedBox(width: 4),

// 2. INTERACTIVE EDIT ACTION BUTTON
                  IconButton(
                    icon: const Icon(
                        Icons.edit_outlined, color: Colors.blue, size: 18),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      final amountEditController = TextEditingController(
                          text: item.amount.toString());
                      final descEditController = TextEditingController(
                          text: item.description);

                      showDialog(
                        context: context,
                        builder: (dialogCtx) =>
                            AlertDialog(
                              title: Text('Modify Record Entry',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold)),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: amountEditController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        labelText: 'Amount (Rs.)'),
                                  ),
                                  TextField(
                                    controller: descEditController,
                                    decoration: const InputDecoration(
                                        labelText: 'Description / Reference Note'),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(dialogCtx),
                                    child: const Text('Cancel')),
                                ElevatedButton(
                                  onPressed: () async {
                                    final double? newAmt = double.tryParse(
                                        amountEditController.text.trim());
                                    if (newAmt != null && newAmt > 0) {
// it will brought data from db that we had use firebase
                                      await dbRef.child(item.id).update({
                                        'amount': newAmt,
                                        'description': descEditController.text
                                            .trim(),
                                      });
                                      if (context.mounted) Navigator.pop(
                                          dialogCtx);
                                    }
                                  },
                                  child: const Text('Save Changes'),
                                ),
                              ],
                            ),
                      );
                    },
                  ),
                  const SizedBox(width: 6),

// in it we have coded about the delete icon code see
                  IconButton(
                    icon: const Icon(
                        Icons.delete_outline_rounded, color: Colors.redAccent,
                        size: 18),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () async {
                      await dbRef.child(item.id).remove();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text(
                              'Transaction record deleted successfully.'),
                              behavior: SnackBarBehavior.floating),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildBottomNavigationBar() {
    return LiquidGlassBottomNavBar(
      currentIndex: _selectedNavIndex,
      onTap: (index) {
        setState(() {
          _selectedNavIndex = index;
        });
      },
    );
  }
}
