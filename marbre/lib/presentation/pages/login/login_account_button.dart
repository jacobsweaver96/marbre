import 'package:flutter/material.dart';
import 'package:marbre/presentation/router/router.dart';

class CreateAccountButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        'Create an Account',
      ),
      onPressed: () {
        navigator.navigateTo(context, '/register');
      },
    );
  }
}