import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:marbre/domain/marbler/password.dart';
import 'package:marbre/domain/services/services.dart';
import 'package:marbre/domain/shared/shared.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthFacade _authFacade;

  LoginBloc({
    @required AuthFacade authFacade,
  })
  : assert(authFacade != null),
    _authFacade = authFacade;

  @override
  LoginState get initialState => LoginState.empty();

  @override
  Stream<Transition<LoginEvent, LoginState>> transformEvents(
    Stream<LoginEvent> events,
    TransitionFunction<LoginEvent, LoginState> transitionFunction,
  ) {
    final nonDebounceStream = events.where((event) =>
      event is! EmailChanged && event is! PasswordChanged
    );

    final debounceStream = events.where((event) => 
      event is EmailChanged || event is PasswordChanged
    )
    .debounceTime(Duration(milliseconds: 300));

    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFunction,
    );
  }

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is LoginWithGooglePressed) {
      yield* _mapLoginWithGooglePressed();
    } else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressed(
        email: event.email,
        password: event.password
      );
    }
  }

  Stream<LoginState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: EmailAddress.isValid(email),
    );
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: Password.isValid(password),
    );
  }

  Stream<LoginState> _mapLoginWithGooglePressed() async* {
    try {
      await _authFacade.googleSignIn();
      yield LoginState.success();
    } catch (_) {
      yield LoginState.failure();
    }
  }

  Stream<LoginState> _mapLoginWithCredentialsPressed({
    String email,
    String password,
  }) async* {
    final $fail = ($) => LoginState.failure();
    final $success = ($) => LoginState.success();

    yield await EmailAddress
      .create(email).map(($email) => Password
        .create(password).map(($password) async => await _authFacade
          .signIn(
            email: $email,
            password: $password,
          )
        )
      )
      .fold($fail, ($continue) => $continue
        .fold($fail, ($future) async => (await $future)
          .fold($fail,
            $success
          )
        )
      );
  }
}
