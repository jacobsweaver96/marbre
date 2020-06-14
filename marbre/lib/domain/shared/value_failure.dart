class Failure {
  const Failure(this.message);

  final String message;
}

class ValueFailure<TValue> extends Failure {
  ValueFailure._(this.value, String message): super(message);

  factory ValueFailure(TValue value, String message) {
    return ValueFailure._(value, message);
  }

  final TValue value;
}