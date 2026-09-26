import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class AddIncomeScreen extends StatefulWidget {
  const AddIncomeScreen({super.key});

  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'Salary';

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveIncome() async {
    if (_formKey.currentState!.validate()) {
      double amount = double.parse(_amountController.text.trim());
      String desc = _descriptionController.text.trim();

      Map<String, dynamic> incomeData = {
        'category': _selectedCategory,
        'description': desc.isNotEmpty ? desc : _selectedCategory,
        'amount': amount,
        'isIncome': true,
        'type': 'Income',
        'transactionType': 'income',
        'dateOrTime': DateTime.now().toIso8601String().substring(0, 10),
      };

      try {

        final DatabaseReference dbRef = FirebaseDatabase.instanceFor(app: Firebase.app(),
          databaseURL: 'https://pennypal-de604-default-rtdb.firebaseio.com/',
        ).ref().child('transactions');

        await dbRef.push().set(incomeData);

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
      appBar: AppBar(title: const Text('Add Income')),
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

              // 2. Category Dropdown Field
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: ['Salary', 'Freelance Work', 'Allowance', 'Others']
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
              ),
              const SizedBox(height: 16),

              // 3. Description Field
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description / Source'),
              ),
              const SizedBox(height: 24),

              // 4. Save Button
              ElevatedButton(
                onPressed: _saveIncome,
                child: const Text('Save Income'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
