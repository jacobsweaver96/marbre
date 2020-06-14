import 'package:flutter/material.dart';

import 'router/router.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marbre',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      onGenerateRoute: navigator.generator,
      initialRoute: '/',
    );
  }
}