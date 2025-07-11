import 'package:finance_tracker/data/classes/entities/category_entity.dart';
import 'package:finance_tracker/data/classes/repo/authentication_repository.dart';
import 'package:finance_tracker/data/classes/repo/firebase_expense_repo.dart';
import 'package:finance_tracker/data/notifiers.dart';
import 'package:finance_tracker/widgets/chart.dart';
import 'package:finance_tracker/widgets/list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseExpenseRepo = FirebaseExpenseRepo(
      authenticationRepository: context.read<AuthenticationRepository>(),
    );
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return Container(
      //color: Colors.green,
      width: double.infinity,
      child: isLandscape
          ? Row(
              children: [
                Expanded(child: ChartWidget(firebaseExpenseRepo: firebaseExpenseRepo)),
                const Expanded(child: ListWidget()),
                
              ],
            )
          : Column(
              children: [
                Expanded(child: ChartWidget(firebaseExpenseRepo: firebaseExpenseRepo)),
                const Expanded(child: ListWidget()),
              ],
            ),
    );
  }
}
