import 'package:dartz/dartz.dart';
import 'package:marbre/domain/shared/shared.dart';
import 'package:marbre/domain/shared/value_failure.dart';

class EmailAddress {
  const EmailAddress._(this.value);

  static Either<ValueFailure<String>, EmailAddress> create(String value) {
    return isValid(value) ? right(EmailAddress._(value)) : left(ValueFailure(value, FailureMessages.invalidEmail));
  }

  static bool isValid(String value) {
    return ValidationRegex.emailRegex.hasMatch(value);
  }

  final String value;
}