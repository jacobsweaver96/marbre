import 'package:fluro/fluro.dart';

import 'router_routes.dart';
import 'router_source.dart';

extension RouteConfig on Router {
  void addSource(RouterSource routeSource) {
    this.define(
      routeSource.pathDefinition,
      handler: routeSource.handler,
      transitionType: routeSource.transitionType
    );
  }

  void addSources(List<RouterSource> routeSources) {
    routeSources.forEach(addSource);
  }
}

extension Navigate on Router {
  void navigateToHome(context, String name) {
    this.navigateTo(context, Routes.homeRoute.pathBuilder({
      name: name
    }));
  }

  void navigateToLogin(context) {
    this.navigateTo(context, Routes.loginRoute.pathBuilder({}));
  }

  void navigateToRegister(context) {
    this.navigateTo(context, Routes.registerRoute.pathBuilder({}));
  }
}