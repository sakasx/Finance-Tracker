import 'package:finance_tracker/data/classes/repo/authentication_repository.dart';
import 'package:finance_tracker/data/notifiers.dart';
import 'package:finance_tracker/views/pages/app/bloc/bloc/app_bloc.dart';
import 'package:finance_tracker/views/pages/welcome_page.dart';
import 'package:finance_tracker/views/pages/widget_tree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatelessWidget {
  const App({required AuthenticationRepository authenticationRepository, super.key})
    : _authenticationRepository = authenticationRepository;

  final AuthenticationRepository _authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: BlocProvider(
        lazy: false,
        create: (_) =>
            AppBloc(authenticationRepository: _authenticationRepository)
              ..add(const AppUserSubscriptionRequested()),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: isDarkModeNotifier.value ? Brightness.dark : Brightness.light,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          switch (state.status) {
            case AppStatus.authenticated:
              return const WidgetTree();
            case AppStatus.unauthenticated:
              return const WelcomePage();
          }
        },
      ),
    );
  }
}

List<Page<dynamic>> onGenerateAppViewPages(AppStatus state) {
  switch (state) {
    case AppStatus.authenticated:
      return const [MaterialPage(child: WidgetTree())];
    case AppStatus.unauthenticated:
      return const [MaterialPage(child: WelcomePage())];
  }
}

void darkModeSetting() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool? repeat = prefs.getBool('isDarkKey');
  isDarkModeNotifier.value = repeat ?? false;
}
