import 'package:finance_tracker/data/notifiers.dart';
import 'package:finance_tracker/views/hero_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  // Widget build(BuildContext context) {
  //   return const Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 25.0),
  //     child: Column(children: [HeroWidget()]),
  //   );
  // }
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          const HeroWidget(),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 12.0, bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Transactions'),
                GestureDetector(
                  onTap: () {
                    selectedPageNotifier.value = 1;
                  },
                  child: const Text(
                    'See All',
                    textAlign: TextAlign.end,
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, int i) {
                return Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDarkModeNotifier.value ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            width: 35,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Colors.yellow,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          const Text(
                            'Food',
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                          ),
                          const Spacer(),
                          const Column(
                            children: [
                              Text(
                                '-\$20.00',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.red,
                                ),
                              ),
                              Text(
                                'Today',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
