import 'package:finance_tracker/data/classes/entities/category_entity.dart';
import 'package:finance_tracker/data/classes/repo/firebase_expense_repo.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartWidget extends StatelessWidget {
  final FirebaseExpenseRepo firebaseExpenseRepo;
  const ChartWidget({super.key, required this.firebaseExpenseRepo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white, //isDarkModeNotifier.value ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
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
              .where((entry) => entry.type == EntryType.expense)
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
          return Column(
            children: [
              SizedBox(
                height: 225,
                width: 400,
                child: SfCircularChart(
                  margin:  EdgeInsets.zero,
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

                    height: '100%',
                    width: '80%',
                  ),
                  series: <CircularSeries>[
                    DoughnutSeries<CategorySpending, String>(
                      legendIconType: LegendIconType.circle,
                      radius: '75%',
                      innerRadius: '40%',
                      explode: true,
                      dataLabelMapper: (CategorySpending data, _) => data.totalAmount.toString(),
  
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
                //color: Colors.red,
                width: double.infinity,
                //color: Colors.red,
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
                          fontSize: 25,
                          shadows: [Shadow(color: Colors.grey, offset: Offset(1.0, 1.0))],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
