import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:marbre/domain/marbler/marbler.dart';
import 'package:dartz/dartz.dart';
import 'package:marbre/domain/marbler/password.dart';
import 'package:marbre/domain/services/services.dart';
import 'package:marbre/domain/shared/contact/email.dart';
import 'package:marbre/domain/shared/shared.dart';
import 'package:meta/meta.dart';

class FirebaseAuthFacade implements AuthFacade {
  FirebaseAuthFacade({
    @required MarblerFactory marblerFactory,
    @required FirebaseAuth firebaseAuth,
    @required GoogleSignIn googleSignIn,
  })
  : assert(marblerFactory != null),
    assert(firebaseAuth != null),
    assert(googleSignIn != null),
    _marblerFactory = marblerFactory,
    _firebaseAuth = firebaseAuth,
    _googleSignIn = googleSignIn;

  final MarblerFactory _marblerFactory;
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  @override
  Future<Option<Marbler>> getSignedInUser() async {
    var currentFirebaseUser = await _firebaseAuth.currentUser();

    if (currentFirebaseUser == null) {
      return none();
    }

    return some(
      _marblerFactory.createMarbler(
        id: currentFirebaseUser.uid,
        email: currentFirebaseUser.email,
      )
      .getOrElse(() => throw ArgumentError())
    );
  }

  @override
  Future<Either<Failure, Unit>> signIn({
    EmailAddress email,
    Password password
  }) async {
    var result = await _firebaseAuth.signInWithEmailAndPassword(
      email: email.value,
      password: password.value,
    );

    if (result.user == null) {
      return left(Failure(result.toString()));
    }

    return right(unit);
  }

  @override
  Future<Either<Failure, Unit>> googleSignIn() async {
    var googleUser = await _googleSignIn.signIn();
    var googleAuth = await googleUser.authentication;
    var credential = GoogleAuthProvider.getCredential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    var result = await _firebaseAuth.signInWithCredential(credential);

    if (result.user == null) {
      return left(Failure(result.toString()));
    }

    return right(unit);
  }

  @override
  Future<Either<Failure, Unit>> register({
    EmailAddress email,
    Password password,
  }) async {
    var result = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.value,
      password: password.value,
    );

    if (result.user == null) {
      return left(Failure(result.toString()));
    }

    return right(unit);
  }

  @override
  Future<Unit> signOut() async {
    return await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ])
    .then((value) => unit);
  }
}