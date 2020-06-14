import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marbre/domain/marbler/marbler.dart';
import 'package:marbre/domain/services/services.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthFacade _authFacade;

  AuthBloc({
    @required AuthFacade authFacade,
  })
  : assert(authFacade != null),
    _authFacade = authFacade;

  @override
  AuthState get initialState => Uninitialized();

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
    final $auth = (Marbler $marbler) => Authenticated($marbler.email.value);
    final $unauth = () => Unauthenticated();

    yield await _authFacade
      .getSignedInUser()
      .then(($mMaybe) => $mMaybe
        .fold(
          $unauth,
          $auth,
        )
      );
  }

  Stream<AuthState> _mapLoggedInToState() async* {
    final $auth = ($marbler) => Authenticated($marbler.email.value);
    final $failAssert = () => throw new AssertionError("Invalid process state. User surely expected.");

    yield await _authFacade
      .getSignedInUser()
      .then(($mSurely) => $mSurely
        .map($auth)
        .getOrElse($failAssert)
      );
  }

  Stream<AuthState> _mapLoggedOutToState() async* {
    final $unauth = ($) => Unauthenticated();

    yield await _authFacade
      .signOut()
      .then($unauth);
  }
}
