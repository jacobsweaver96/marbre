import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';

import 'package:marbre/domain/shared/shared.dart';

class UuidV4Factory extends IdFactory {
  @override
  String generate() {
    return Uuid().v4();
  }

  @override
  Option<String> validate(String value) {
    return option(ValidationRegex.uuid4Regex.hasMatch(value), value);
  }
}