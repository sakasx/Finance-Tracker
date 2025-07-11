import 'package:bloc/bloc.dart';
import 'package:finance_tracker/data/classes/entities/objectbox.dart';
import 'package:finance_tracker/data/classes/repo/authentication_repository.dart';
import 'package:finance_tracker/data/classes/repo/firebase_expense_repo.dart';
import 'package:finance_tracker/simple_bloc_observer.dart';
import 'package:finance_tracker/views/pages/app/view/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

late ObjectBox objectbox;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  objectbox = await ObjectBox.create();

  Bloc.observer = SimpleBlocObserver();

  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;

  runApp(App(authenticationRepository: authenticationRepository));
  await FirebaseExpenseRepo(authenticationRepository: authenticationRepository);
}
