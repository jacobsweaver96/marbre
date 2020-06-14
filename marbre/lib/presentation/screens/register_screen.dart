import 'package:flutter/material.dart';
import 'package:marbre/presentation/pages/register/register.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Center(
        child: RegisterForm(),
      ),
    );
  }
}