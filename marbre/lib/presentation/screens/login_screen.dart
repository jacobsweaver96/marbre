import 'package:flutter/material.dart';
import 'package:marbre/presentation/pages/login/login_form.dart';

class LoginScreen extends StatelessWidget {

  LoginScreen({Key key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: LoginForm(),
    );
  }
}