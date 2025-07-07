import 'package:finance_tracker/data/classes/repo/authentication_repository.dart';
import 'package:finance_tracker/views/hero_widget.dart';
import 'package:finance_tracker/views/pages/login_page/cubit/login_page_cubit.dart';
import 'package:finance_tracker/views/pages/login_page/view/login_page.dart';
import 'package:finance_tracker/views/pages/sign_up_page/view/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const HeroWidget(),
            FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              },
              style: FilledButton.styleFrom(minimumSize: const Size(double.infinity, 40)),
              child: const Text('Get Started'),
            ),
            TextButton(
              style: FilledButton.styleFrom(minimumSize: const Size(double.infinity, 40)),

              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) =>
                          LoginCubit(context.read<AuthenticationRepository>()),
                      child: const LoginPage(),
                    ),
                  ),
                );
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
