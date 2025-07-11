import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finance_tracker/data/classes/models/email.dart' show Email;
import 'package:finance_tracker/data/classes/models/password.dart';
import 'package:finance_tracker/data/classes/repo/authentication_repository.dart';
import 'package:finance_tracker/data/classes/repo/firebase_expense_repo.dart';
import 'package:formz/formz.dart';

part 'login_page_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authenticationRepository) : super(const LoginState());

  final AuthenticationRepository _authenticationRepository;

  void emailChanged(String email) => emit(state.withEmail(email));

  void passwordChanged(String password) => emit(state.withPassword(password));

  Future<void> logInWithCredentials() async {
    if (!state.isValid) return;
    emit(state.withSubmissionInProgress());
    try {
      await _authenticationRepository.logIn(
        email: state.email.value,
        password: state.password.value,
      );
      await FirebaseExpenseRepo(authenticationRepository: _authenticationRepository)
        .syncFromFirebaseToObjectBox();
      emit(state.withSubmissionSuccess());
    } on LogInWithEmailAndPasswordFailure catch (e) {
      emit(state.withSubmissionFailure(e.message));
    } catch (_) {
      emit(state.withSubmissionFailure());
      //print(state.email.value);
    }
  }
}
