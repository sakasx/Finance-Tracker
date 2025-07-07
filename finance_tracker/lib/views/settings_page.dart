import 'package:finance_tracker/data/notifiers.dart';
import 'package:finance_tracker/views/pages/app/bloc/bloc/app_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Light/Dark Mode:'),
                  IconButton(
                    onPressed: () async {
                      isDarkModeNotifier.value = !isDarkModeNotifier.value;
                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('isDarkKey', isDarkModeNotifier.value);
                    },
                    icon: ValueListenableBuilder(
                      valueListenable: isDarkModeNotifier,
                      builder: (context, isDarkMode, child) =>
                          Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
                    ),
                  ),
                ],
                //child: Text('Settings Page'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    FilledButton(
                      style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.red)),
                      onPressed: () {
                        context.read<AppBloc>().add(const AppLogoutPressed());
                        Navigator.of(context).pop();
                        // selectedPageNotifier.value = 0;
                        // Navigator.of(context).pushAndRemoveUntil(
                        //   MaterialPageRoute(builder: (context) => const WelcomePage()),
                        //   (Route route) => false,
                        // );
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
