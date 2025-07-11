import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/data/classes/entities/category_entity.dart';
import 'package:finance_tracker/data/classes/repo/authentication_repository.dart';
import 'package:finance_tracker/main.dart';

class FirebaseExpenseRepo {
  FirebaseExpenseRepo({required this.authenticationRepository});
  final expenseCollection = FirebaseFirestore.instance.collection('expenses');
  final AuthenticationRepository authenticationRepository;

  Future<void> createFinancialEntry(FinancialEntry expense) async {
    final id = authenticationRepository.currentUser.id;
    try {
      await objectbox.expenseBox.put(expense);
      unawaited(expenseCollection.doc(id).collection('expenses').add(expense.toJson()));
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Stream<List<FinancialEntry>> getEntry() {
    final id = authenticationRepository.currentUser.id;
    return expenseCollection
        .doc(id)
        .collection('expenses')
        .snapshots()
        .map((event) => event.docs.map((e) => FinancialEntry.fromJson(e.data())).toList());
  }

  Future<void> syncFromFirebaseToObjectBox() async {
    objectbox.expenseBox.removeAll();
    final id = authenticationRepository.currentUser.id;
    final snapshot = await expenseCollection.doc(id).collection('expenses').get();

    final entries = snapshot.docs.map((doc) {
      return FinancialEntry.fromJson(doc.data());
    }).toList();

    objectbox.expenseBox.putMany(entries);
  }
}
