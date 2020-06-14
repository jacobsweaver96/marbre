import 'package:dartz/dartz.dart';
import 'package:marbre/domain/shared/shared.dart';

class Password {
  Password._(this.value);

  static Either<ValueFailure<String>, Password> create(String value) {
    return isValid(value) ? right(Password._(value)) : left(ValueFailure(value, FailureMessages.invalidPassword));
  }

  static bool isValid(String value) {
    return ValidationRegex.passwordRegex.hasMatch(value);
  }

  final String value;
}