import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'logs_screen_event.dart';
part 'logs_screen_state.dart';

class LogsScreenBloc extends Bloc<LogsScreenEvent, LogsScreenState> {
  LogsScreenBloc() : super(LogsScreenInitial()) {
    on<LogsScreenEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
