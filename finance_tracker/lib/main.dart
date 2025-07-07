import 'package:bloc/bloc.dart';
import 'package:finance_tracker/data/classes/repo/authentication_repository.dart';
import 'package:finance_tracker/simple_bloc_observer.dart';
import 'package:finance_tracker/views/pages/app/view/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();

  await Firebase.initializeApp();
  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;

  runApp(App(authenticationRepository: authenticationRepository));
}
