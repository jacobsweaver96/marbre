import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:marbre/domain/services/services.dart';
import 'package:marbre/infrastructure/auth/firebase_auth_facade.dart';
import 'package:marbre/infrastructure/marbler/firebase_marbler.dart';
import 'package:marbre/infrastructure/shared/uuid_v4_factory.dart';
import 'package:provider/provider.dart';

import 'application/auth/auth_bloc.dart';
import 'application/tab/tab_bloc.dart';
import 'infrastructure/app_bloc_delegate.dart';
import 'presentation/app.dart';
import 'presentation/router/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = AppBlocDelegate();
  navigator.addSources(Routes.all);

  var idFactory = UuidV4Factory();
  var marblerFactory = FirebaseMarblerFactory(
    idFactory: idFactory,
  );

  var firebaseAuth = FirebaseAuth.instance;
  var googleSignIn = GoogleSignIn();

  var authFacade = FirebaseAuthFacade(
    marblerFactory: marblerFactory,
    firebaseAuth: firebaseAuth,
    googleSignIn: googleSignIn,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthFacade>(create: (_) => authFacade),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(create: (_) => AuthBloc(authFacade: authFacade)),
          BlocProvider<TabBloc>(create: (_) => TabBloc()),
        ],
        child: App(),
      ),
    ),
  );
}