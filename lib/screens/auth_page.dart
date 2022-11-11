// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../models/auth_form_data.dart';
import '../widgets/auth.form.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  bool _isLoading = false;

  void _handleSubmit(AuthFormData formData) {
    setState(() {
      _isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: AuthForm(onSubmit: _handleSubmit),
            ),
          ),
          if(_isLoading)
          Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.5),
            ),
            child: Center(child: CircularProgressIndicator()),
          )
        ],
      ),
    );
  }
}
