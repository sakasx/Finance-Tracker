import 'package:finance_tracker/data/classes/entities/category_entity.dart';
import 'package:finance_tracker/data/classes/repo/authentication_repository.dart';
import 'package:finance_tracker/data/classes/repo/firebase_expense_repo.dart';
import 'package:finance_tracker/data/notifiers.dart';
import 'package:finance_tracker/main.dart';
import 'package:finance_tracker/views/pages/create_expense_screen/bloc/create_expense_bloc.dart';
import 'package:finance_tracker/views/pages/create_expense_screen/view/create_expense_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final firebaseExpenseRepo = FirebaseExpenseRepo(
      authenticationRepository: context.read<AuthenticationRepository>(),
    );
    return Scaffold(
      body: StreamBuilder<List<FinancialEntry>>(
        stream: objectbox.expenseStream.map((query) => query.find()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Entries found.'));
          } else {
            final entries = snapshot.data!;
            entries.sort((a, b) => b.date.compareTo(a.date));
            return ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return Padding(
                  padding: const EdgeInsets.all(7.0),
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
