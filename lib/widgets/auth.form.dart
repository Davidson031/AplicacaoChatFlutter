import 'package:flutter/material.dart';

import '../models/auth_form_data.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {

  final _formKey = GlobalKey<FormState>();
  final _authData = AuthFormData();

  void _submitForm(){

  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if(_authData.isSignUp)
              TextFormField(
                key: const ValueKey('name'),
                decoration: const InputDecoration(labelText: 'Nome'),
                initialValue: _authData.name,
                onChanged: (value) => _authData.name = value,
              ),
              TextFormField(
                key: const ValueKey('email'),
                initialValue: _authData.email,
                onChanged: (value) => _authData.email = value,
                decoration: const InputDecoration(labelText: 'E-mail'),
              ),
              TextFormField(
                key: const ValueKey('password'),
                initialValue: _authData.password,
                onChanged: (value) => _authData.password = value,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(_authData.isLogin ? 'Entrar' : 'Cadastrar'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _authData.toggleAuthMode();
                  });
                },
                child: Text(_authData.isLogin ? 'Criar uma nova conta?' : 'Já possui uma conta?'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
