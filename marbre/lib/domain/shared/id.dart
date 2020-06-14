import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

class Id {
  const Id._(this.value);

  final String value;

  int get hashCode => value.hashCode;

  bool operator ==(other) {
    return value == other.value;
  }
}

abstract class IdFactory {
  Id create({
    String value,
  }) {
    if (value == null) {
      return Id._(generate());
    }

    return validate(value)
      .map(($id) => Id._($id))
      .getOrElse(() => throw new ArgumentError("Invalid Id format"));
  }

  @protected
  String generate();

  @protected
  Option<String> validate(String value);
}