import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finance_tracker/data/classes/entities/category_entity.dart';
import 'package:finance_tracker/data/classes/repo/firebase_expense_repo.dart';

part 'create_expense_event.dart';
part 'create_expense_state.dart';

class CreateExpenseBloc extends Bloc<CreateExpenseEvent, CreateExpenseState> {
  final FirebaseExpenseRepo expenseRepository;

  CreateExpenseBloc(this.expenseRepository) : super(const CreateExpenseState()) {
    on<CreateExpenseEntry>((event, emit) async {
      emit(const CreateExpenseState(status: CreateExpenseStatus.loading));
      try {
        await expenseRepository.createFinancialEntry(event.entry);
        emit(const CreateExpenseState(status: CreateExpenseStatus.success));
      } catch (e) {
        emit(const CreateExpenseState(status: CreateExpenseStatus.error));
      }
    });
  }
}
