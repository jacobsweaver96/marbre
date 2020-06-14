import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:marbre/domain/marbler/password.dart';
import 'package:marbre/domain/services/services.dart';
import 'package:marbre/domain/shared/shared.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthFacade _authFacade;

  RegisterBloc({
    @required AuthFacade authFacade,
  })
  : assert(AuthFacade != null),
    _authFacade = authFacade;

  @override
  RegisterState get initialState => RegisterState.empty();

  @override
  Stream<Transition<RegisterEvent, RegisterState>> transformEvents(
    Stream<RegisterEvent> events,
    TransitionFunction<RegisterEvent, RegisterState> transitionFn,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! EmailChanged && event is! PasswordChanged);
    });
    final debounceStream = events.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is Submitted) {
      yield* _mapFormSubmittedToState(event.email, event.password);
    }
  }

  Stream<RegisterState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: EmailAddress.isValid(email),
    );
  }

  Stream<RegisterState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: Password.isValid(password),
    );
  }

  Stream<RegisterState> _mapFormSubmittedToState(
    String email,
    String password,
  ) async* {
    final $fail = ($) => RegisterState.failure();
    final $success = ($) => RegisterState.success();

    yield RegisterState.loading();
    yield await EmailAddress
      .create(email).map(($email) => Password
        .create(password).map(($password) async => await _authFacade
          .register(
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
