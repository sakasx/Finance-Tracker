import 'package:finance_tracker/data/classes/entities/category_entity.dart';
import 'package:finance_tracker/data/classes/repo/authentication_repository.dart';
import 'package:finance_tracker/data/classes/repo/firebase_expense_repo.dart';
import 'package:finance_tracker/data/notifiers.dart';
import 'package:finance_tracker/views/pages/create_expense_screen/bloc/create_expense_bloc.dart';
import 'package:finance_tracker/views/pages/create_expense_screen/view/create_expense_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogsPage extends StatelessWidget {
  const LogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseExpenseRepo = FirebaseExpenseRepo(
      authenticationRepository: context.read<AuthenticationRepository>(),
    );

    return Scaffold(
      body: StreamBuilder<List<FinancialEntry>>(
        stream: firebaseExpenseRepo.getEntry(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While loading show progress indicator
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Show error message
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Show empty state if no data
            return const Center(child: Text('No Entries found.'));
          } else {
            // Data loaded successfully, show list
            final entries = snapshot.data!;
            return Container(
              padding: EdgeInsets.only(bottom: 75),
              child: ListView.builder(
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return Padding(
                    padding: const EdgeInsets.only(left:7.0, right: 7.0, top: 7.0, bottom: 4),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDarkModeNotifier.value ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Container(
                              child: Icon(entry.category.icon, color: Colors.white),
                              width: 35,
                              height: 40,
                              decoration: BoxDecoration(
                                color: entry.category.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            Text(
                              entry.category.name,
                              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${entry.type.valueType}${entry.amount.toString()}', //'entry.type.text entry.amount.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: entry.type.color,
                                  ),
                                ),
                                Text(
                                  entry.date.toString().substring(0, 10),
                                  textAlign: TextAlign.end,
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
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(side: BorderSide(color: Colors.teal)),
        backgroundColor: Colors.teal[100],
        child: const Icon(Icons.add, color: Colors.white, size: 30),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => CreateExpenseBloc(firebaseExpenseRepo),
                child: const AddExpensePage(),
              ),
            ),
          );
        },
      ),
    );
  }
}
