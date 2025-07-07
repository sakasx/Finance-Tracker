part of 'create_expense_bloc.dart';

sealed class CreateExpenseEvent extends Equatable {
  const CreateExpenseEvent();

  @override
  List<Object> get props => [];
}

class CreateExpenseEntry extends CreateExpenseEvent {
  final FinancialEntry entry;

  const CreateExpenseEntry(this.entry);

  @override
  List<Object> get props => [entry];
}
