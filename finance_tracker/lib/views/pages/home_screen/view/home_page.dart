import 'package:finance_tracker/data/classes/repo/authentication_repository.dart';
import 'package:finance_tracker/data/classes/repo/expense_repository.dart';
import 'package:finance_tracker/data/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
    final firebaseExpenseRepo = FirebaseExpenseRepo(
      authenticationRepository: context.read<AuthenticationRepository>(),
    );
    return Container(
      color: Colors.green,
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: StreamBuilder(
              stream: firebaseExpenseRepo.getEntry(),
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (asyncSnapshot.hasError) {
                  return Center(child: Text('Error: ${asyncSnapshot.error}'));
                } else if (!asyncSnapshot.hasData || asyncSnapshot.data!.isEmpty) {
                  return const Center(child: Text('No Entries found.'));
                }

                final entries = asyncSnapshot.data!
                    .where((entry) => entry.type == Type.expense)
                    .toList();

                final Map<Category, double> categoryTotals = {};
                double totalSpent = 0.0;

                for (var entry in entries) {
                  categoryTotals.update(
                    entry.category,
                    (value) => value + entry.amount,
                    ifAbsent: () => entry.amount,
                  );
                  totalSpent += entry.amount;
                }
                final chartData = categoryTotals.entries
                    .map((e) => CategorySpending(category: e.key, totalAmount: e.value))
                    .toList();
                return Container(
                  color: Colors.blue,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 300,
                        width: 400,
                        child: SfCircularChart(
                          margin: const EdgeInsets.all(0),
                          palette: [
                            Colors.green.shade300,
                            Colors.orange.shade300,
                            Colors.red.shade300,
                            Colors.blue.shade200,
                            Colors.yellow.shade300,
                          ],
                          legend: const Legend(
                            isVisible: true,
                            position: LegendPosition.right,
                            overflowMode: LegendItemOverflowMode.none,
                            orientation: LegendItemOrientation.vertical,

                            height: '50%',
                            width: '80%',
                          ),
                          series: <CircularSeries>[
                            DoughnutSeries<CategorySpending, String>(
                              legendIconType: LegendIconType.circle,
                              radius: '75%',
                              innerRadius: '40%',
                              explode: true,
                              dataLabelMapper: (CategorySpending data, _) =>
                                  data.totalAmount.toString(),

                              dataLabelSettings: const DataLabelSettings(isVisible: true),

                              dataSource: [
                                for (var entry in chartData)
                                  CategorySpending(
                                    category: entry.category,
                                    totalAmount: entry.totalAmount,
                                  ),
                              ],
                              xValueMapper: (CategorySpending data, _) => data.category.name,
                              yValueMapper: (CategorySpending data, _) => data.totalAmount,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        //color: Colors.red,
                        width: double.infinity,
                        color: Colors.red,
                        height: 50,
                        child: Card(
                          margin: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Total spent: ${totalSpent.toStringAsFixed(2)}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  shadows: [Shadow(color: Colors.grey, offset: Offset(1.0, 1.0))],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          //const HeroWidget(),
          //const SizedBox(height: 10.0),
          Expanded(
            child: Column(
              children: [
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
                                  decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                Text(
                                  'Groceries',
                                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                                ),
                                const Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '-\$20.00',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: Colors.red,
                                      ),
                                    ),
                                    Text(
                                      'Today', // Ideally format entry.date
                                      style: const TextStyle(
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
          ),
        ],
      ),
    );
  }
}
