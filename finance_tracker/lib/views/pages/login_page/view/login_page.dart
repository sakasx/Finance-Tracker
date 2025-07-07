import 'package:finance_tracker/data/classes/repo/authentication_repository.dart';
import 'package:finance_tracker/views/pages/app/bloc/bloc/app_bloc.dart';
import 'package:finance_tracker/views/pages/login_page/cubit/login_page_cubit.dart';
import 'package:finance_tracker/views/pages/login_page/view/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocProvider(
          create: (_) => LoginCubit(context.read<AuthenticationRepository>()),
          child: BlocListener<AppBloc, AppState>(
            listenWhen: (previous, current) => previous.status != current.status,
            listener: (context, state) {
              //Navigator.of(context).pop();
            },
            child: const LoginForm(), //TODO: RETURN LATER
          ),
        ),
      ),
    );
  }
}
