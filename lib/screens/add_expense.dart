import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // 🟢 Added core Firebase package import
import 'package:firebase_database/firebase_database.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Default mandated expense category from your project guidelines
  String _selectedCategory = 'Food & Dining';

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveExpense() async {
    if (_formKey.currentState!.validate()) {
      double amount = double.parse(_amountController.text.trim());
      String desc = _descriptionController.text.trim();

      // Structure expense data payload matching your backend stream logic
      Map<String, dynamic> expenseData = {
        'category': _selectedCategory,
        'description': desc.isNotEmpty ? desc : _selectedCategory,
        'amount': amount,
        'isIncome': false, // Configured as false for Expenses
        'type': 'Expense', // Flags database calculation as Expense
        'transactionType': 'expense',
        'dateOrTime': DateTime.now().toIso8601String().substring(0, 10),
      };

      try {
        // fix the error by adding the db url here also see
        final DatabaseReference dbRef = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL: 'https://pennypal-de604-default-rtdb.firebaseio.com/',
        ).ref().child('transactions');


        await dbRef.push().set(expenseData);

        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Firebase Database Error: $e'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 1. Amount Field
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount (Rs.)'),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Enter amount';
                  if (double.tryParse(val) == null) return 'Enter a number';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 2. Category Dropdown Field (Pre-populated with your SRS expense categories)
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: [
                  'Food & Dining',
                  'Transport',
                  'Shopping',
                  'Education',
                  'Entertainment',
                  'Bills',
                  'Others'
                ].map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
              ),
              const SizedBox(height: 16),

              // 3. Merchant / Description Field
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Merchant / Description'),
              ),
              const SizedBox(height: 24),

              // 4. Save Button
              ElevatedButton(
                onPressed: _saveExpense,
                child: const Text('Save Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
