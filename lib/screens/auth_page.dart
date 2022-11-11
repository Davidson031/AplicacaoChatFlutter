// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../widgets/auth.form.dart';


class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: SingleChildScrollView(
          child: AuthForm(),
        ),
      ),
    );
  }
}