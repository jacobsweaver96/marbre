import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:marbre/features/auth/index.dart';
import 'package:marbre/services/auth/user_repository.dart';
import 'package:meta/meta.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository _userRepository;

  AuthBloc({@required UserRepository userRepository})
    : assert(userRepository != null),
      _userRepository = userRepository;

  @override
  AuthState get initialState => UnInitState();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthState> _mapAppStartedToState() async* {
    final isSignedIn = await _userRepository.isSignedIn();

    if (isSignedIn) {
      final name = await _userRepository.getUser();
      yield InAuthState(name);
    } else {
      yield UnAuthState();
    }
  }

  Stream<AuthState> _mapLoggedInToState() async* {
    yield InAuthState(await _userRepository.getUser());
  }

  Stream<AuthState> _mapLoggedOutToState() async* {
    yield UnAuthState();
    _userRepository.signOut();
  }
}
