part of 'create_expense_bloc.dart';

enum CreateExpenseStatus { initial, loading, success, error }


class CreateExpenseState extends Equatable {

  final CreateExpenseStatus status;
  const CreateExpenseState({this.status = CreateExpenseStatus.initial});

  @override
  List<Object> get props => [];
}
