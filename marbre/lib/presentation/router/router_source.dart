import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

class RouterSource {
  RouterSource({
    @required this.pathDefinition,
    @required Widget Function(BuildContext, Map<String, List<String>>) handlerFunc,
    HandlerType handlerType,
    this.transitionType,
  })
  : assert(pathDefinition != null),
    assert(handlerFunc != null),
    this.handler = Handler(
      type: handlerType,
      handlerFunc: handlerFunc,
    );

  final String pathDefinition;
  final Handler handler;
  final TransitionType transitionType;

  String pathBuilder(Map<String, String> params) {
    var path = this.pathDefinition;

    params.forEach((key, value) {
      var regex = RegExp(":$key", caseSensitive: false);
      path = path.replaceAll(regex, value);
    });

    return path;
  }
}