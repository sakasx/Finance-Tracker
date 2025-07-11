import 'package:finance_tracker/data/notifiers.dart';
import 'package:flutter/material.dart';

class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: NavigationBar(
            indicatorShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            backgroundColor: Colors.grey[100],
            indicatorColor: Colors.grey[300],
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home),
                label: 'Analysis',
                selectedIcon: Icon(Icons.home_outlined),
              ),
              NavigationDestination(
                icon: Icon(Icons.inbox),
                label: 'Logs',
                selectedIcon: Icon(Icons.inbox_outlined),
              ),
              NavigationDestination(
                icon: Icon(Icons.account_circle),
                label: 'Profile',
                selectedIcon: Icon(Icons.account_circle_outlined),
              ),
            ],
            onDestinationSelected: (int value) {
              selectedPageNotifier.value = value;
            },
            selectedIndex: selectedPage,
            height: 70,
          ),
        );
      },
    );
  }
}
