import 'package:dartz/dartz.dart';
import 'package:marbre/domain/marbler/marbler.dart';
import 'package:marbre/domain/shared/shared.dart';
import 'package:meta/meta.dart';

class FirebaseMarbler extends Marbler {
  FirebaseMarbler._({
    @required Id id,
    @required EmailAddress email,
  })
  : super(
    id: id,
    email: email,
  );
}

class FirebaseMarblerFactory implements MarblerFactory {
  FirebaseMarblerFactory({
    @required IdFactory idFactory,
  })
  : assert(idFactory != null),
    _idFactory = idFactory;

  final IdFactory _idFactory;

  @override
  Either<ValueFailure, Marbler> createMarbler({
    String id,
    @required String email,
  }) {
    var $id = _idFactory.create(value: id);
    var $emailMaybe = EmailAddress.create(email);

    return $emailMaybe
      .map(($email) => FirebaseMarbler._(
        id: $id,
        email: $email,
      ));
  }
}