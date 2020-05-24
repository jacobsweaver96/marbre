import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marbre/app_bloc_delegate.dart';
import 'package:marbre/features/auth/auth_bloc.dart';
import 'package:marbre/screens/home_screen.dart';
import 'package:marbre/screens/login/login_screen.dart';
import 'package:marbre/services/auth/user_repository.dart';
import 'package:marbre/splash_screen.dart';

import 'features/auth/auth_event.dart';
import 'features/auth/auth_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = AppBlocDelegate();

  final UserRepository userRepository = UserRepository();

  runApp(
    BlocProvider(
      create: (context) => AuthBloc(userRepository: userRepository)
        ..add(AppStarted()),
      child: App(userRepository: userRepository),
    )
  );
}

class App extends StatelessWidget {
  final UserRepository _userRepository;

  App({Key key, @required UserRepository userRepository})
    : assert(userRepository != null),
    _userRepository = userRepository,
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is UnInitState) {
            return SplashScreen();
          }

          if (state is UnAuthState) {
            return LoginScreen(userRepository: _userRepository);
          }

          if (state is InAuthState) {
            return HomeScreen(name: state.displayName);
          }

          return Container();
        },
      ),
    );
  }
}
