import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import 'package:marbre/domain/shared/shared.dart';

abstract class Marbler implements Entity {
  Marbler({
    @required Id id,
    @required EmailAddress email,
  })
  : assert(id != null),
    assert(email != null),
    this.id = id,
    this.email = email;

  final Id id;
  final EmailAddress email;
}

abstract class MarblerFactory {
  Either<ValueFailure, Marbler> createMarbler({
    String id,
    @required String email,
  });
}