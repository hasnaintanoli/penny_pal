import 'package:firebase_database/firebase_database.dart';

class DatabaseService {

  final  DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('transactions');

  Future<void> saveTranscationtoDatabase(String type, double amount, String category  )async {
  await _dbRef.push().set({
  'type': type,
  'amount': amount,
  'category': category,
  });
  }
  }

