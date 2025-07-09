import 'package:finance_tracker/data/notifiers.dart';
import 'package:finance_tracker/views/pages/home_screen/view/home_page.dart';
import 'package:finance_tracker/views/pages/logs_screen/view/logs_page.dart';
import 'package:finance_tracker/views/pages/profile_page.dart';
import 'package:finance_tracker/views/settings_page.dart';
import 'package:finance_tracker/widgets/navbar.dart';
import 'package:flutter/material.dart';

List<Widget> pages = [const HomePage(), const LogsPage(), const ProfilePage()];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Tracker'),

        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage(title: 'Settings')),
              );
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (context, selectedPage, child) {
          return pages.elementAt(selectedPage);
        },
      ),
      bottomNavigationBar: const NavbarWidget(),
    );
  }
}
