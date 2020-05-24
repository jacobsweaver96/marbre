import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  final List propss;
  AuthState([this.propss]);

  @override
  List<Object> get props => (propss ?? []);
}

class UnInitState extends AuthState {}

class UnAuthState extends AuthState {}

class InAuthState extends AuthState {
  final String displayName;

  InAuthState(this.displayName) : super([displayName]);

  @override
  String toString() => 'Authenticated $displayName';

}

class ErrorAuthState extends AuthState {
  final String errorMessage;

  ErrorAuthState(this.errorMessage): super([errorMessage]);
  
  @override
  String toString() => 'ErrorAuthState';
}
