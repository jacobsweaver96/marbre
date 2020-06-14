
import 'package:marbre/presentation/screens/home_screen.dart';
import 'package:marbre/presentation/screens/login_screen.dart';
import 'package:marbre/presentation/screens/register_screen.dart';

import 'router_source.dart';

class Routes {
  static final RouterSource homeRoute = RouterSource(
    pathDefinition: '/',
    handlerFunc: (context, params) {
      return HomeScreen();
    }
  );

  static final RouterSource loginRoute = RouterSource(
    pathDefinition: '/login',
    handlerFunc: (context, params) {
      return LoginScreen();
    },
  );

  static final RouterSource registerRoute = RouterSource(
    pathDefinition: '/register',
    handlerFunc: (context, params) {
      return RegisterScreen();
    },
  );

  static final List<RouterSource> all = [
    loginRoute,
    homeRoute,
    registerRoute,
  ];
}