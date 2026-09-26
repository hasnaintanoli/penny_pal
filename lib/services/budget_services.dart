import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class BudgetService {
  // in this we had overwrite the db url to make it work
  final DatabaseReference _budgetRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://firebaseio.com',
  ).ref().child('budgets');

  // in this we had  create monthly budget
  Future<void> setBudget(String category, double limit) async {
    await _budgetRef.child(category).set({
      'categoryName': category,
      'budgetLimit': limit,
      'dateRange': 'May 1 – May 31, 2026',
    });
  }


  Future<void> updateBudgetLimit(String category, double newLimit) async {
    await _budgetRef.child(category).update({'budgetLimit': newLimit});
  }

  Future<void> deleteBudget(String category) async {
    await _budgetRef.child(category).remove();
  }

  // Read budget settings continuously
  Stream<DatabaseEvent> getBudgetsStream() {
    return _budgetRef.onValue;
  }
}
