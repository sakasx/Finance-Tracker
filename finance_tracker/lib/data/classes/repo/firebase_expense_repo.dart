import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/data/classes/repo/authentication_repository.dart';
import 'package:finance_tracker/data/classes/repo/expense_repository.dart';

class FirebaseExpenseRepo {
  FirebaseExpenseRepo({required this.authenticationRepository});
  final expenseCollection = FirebaseFirestore.instance.collection('expenses');
  final AuthenticationRepository authenticationRepository;

  Future<void> createFinancialEntry(FinancialEntry expense) async {
    final id = authenticationRepository.currentUser.id;
    try {
      await expenseCollection.doc(id).collection('expenses').add(expense.toJson());
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

  // Future<List<FinancialEntry>> getEntry() async {
  //   final id = authenticationRepository.currentUser.id;
  //   try {
  //     return await expenseCollection
  //         .doc(id)
  //         .collection('expenses')
  //         .get()
  //         .then((value) => value.docs.map((e) => FinancialEntry.fromJson(e.data())).toList());
  //   } catch (e) {
  //     log(e.toString());
  //     rethrow;
  //   }
  // }
}
