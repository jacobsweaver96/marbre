import 'package:dartz/dartz.dart';
import 'package:marbre/domain/marbler/marbler.dart';
import 'package:marbre/domain/marbler/password.dart';
import 'package:marbre/domain/shared/shared.dart';
import 'package:meta/meta.dart';

abstract class AuthFacade {
  Future<Option<Marbler>> getSignedInUser();

  Future<Either<Failure, Unit>> register({
    @required EmailAddress email,
    @required Password password,
  });

  Future<Either<Failure, Unit>> signIn({
    @required EmailAddress email,
    @required Password password,
  });

  Future<Either<Failure, Unit>> googleSignIn();

  Future<Unit> signOut();
}