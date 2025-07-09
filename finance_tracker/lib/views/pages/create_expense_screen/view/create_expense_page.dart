import 'package:finance_tracker/data/classes/repo/authentication_repository.dart';
import 'package:finance_tracker/data/classes/repo/expense_repository.dart';
import 'package:finance_tracker/views/pages/create_expense_screen/bloc/create_expense_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  TextEditingController ammountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  DateTime? selectedDate = DateTime.now();

  @override
  void initState() {
    dateController.text = selectedDate.toString().substring(0, 10);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateExpenseBloc, CreateExpenseState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Padding(
                    padding: const EdgeInsets.all(30.0),

                    child: const Text(
                      'Add Expense',
                      style: (TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  DropdownButton(
                    hint: const Text('Category'),
                    value: categoryController.text.isEmpty ? null : categoryController.text,
                    items: Category.values
                        .map((e) => DropdownMenuItem(value: e.name, child: Text(e.name)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        categoryController.text = value!;
                      });
                    },
                  ),
                  DropdownButton(
                    hint: const Text('Category'),
                    value: typeController.text.isEmpty ? null : typeController.text,
                    items: Type.values
                        .map((e) => DropdownMenuItem(value: e.name, child: Text(e.name)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        typeController.text = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: ammountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Amount',
                    ),
                    onEditingComplete: () {
                      setState(() {}); //NOPE
                    },
                  ),
                  const SizedBox(height: 20.0),

                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Description',
                    ),
                    onEditingComplete: () {
                      setState(() {});
                    },
                  ),

                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: dateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Date',
                    ),
                    onTap: () async {
                      final DateTime? renameDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2023),
                        lastDate: DateTime.now(),
                      );
                      if (renameDate != null) {
                        setState(() {
                          dateController.text = renameDate.toString().substring(0, 10);
                          selectedDate = renameDate;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () async {
                      await onAddButtonPressed(context);
                    },
                    style: FilledButton.styleFrom(minimumSize: const Size(double.infinity, 40)),
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> onAddButtonPressed(BuildContext context) async {
    //TODO sutvarkyt kad butu grazu
    if (typeController.text.isNotEmpty &&
        ammountController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        categoryController.text.isNotEmpty &&
        dateController.text.isNotEmpty) {
      final expense = FinancialEntry(
        amount: double.parse(ammountController.text),
        description: descriptionController.text,
        type: Type.values.firstWhere((element) => element.name == typeController.text),
        category: Category.values.firstWhere((element) => element.name == categoryController.text),
        date: selectedDate!,
      );
      await FirebaseExpenseRepo(
        authenticationRepository: context.read<AuthenticationRepository>(),
      ).createFinancialEntry(expense);
      Navigator.pop(context);
    }
  }
}
