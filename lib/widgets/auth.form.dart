import 'dart:io';

import 'package:chat/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';

import '../models/auth_form_data.dart';

class AuthForm extends StatefulWidget {
  final void Function(AuthFormData) onSubmit;

  const AuthForm({super.key, required this.onSubmit});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _formData = AuthFormData();

  void _handleImagePick(File image) {
    _formData.image = image;
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Theme.of(context).errorColor,
      ),
    );
  }

  void _submitForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (_formData.image == null && _formData.isSignUp) {
      return _showError('Imagem não carregada');
    }

    widget.onSubmit(_formData);
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
              if (_formData.isSignUp)
                UserImagePicker(onImagePick: _handleImagePick),
              if (_formData.isSignUp)
                TextFormField(
                  key: const ValueKey('name'),
                  decoration: const InputDecoration(labelText: 'Nome'),
                  initialValue: _formData.name,
                  onChanged: (value) => _formData.name = value,
                  validator: (value) {
                    final name = value ?? '';
                    if (name.trim().length < 5) {
                      return 'Nome deve ser maior que 5';
                    }
                    return null;
                  },
                ),
              TextFormField(
                key: const ValueKey('email'),
                initialValue: _formData.email,
                onChanged: (value) => _formData.email = value,
                decoration: const InputDecoration(labelText: 'E-mail'),
                validator: (value) {
                  final email = value ?? '';

                  if (!email.contains("@")) {
                    return 'E-mail inválido';
                  }
                  return null;
                },
              ),
              TextFormField(
                key: const ValueKey('password'),
                initialValue: _formData.password,
                onChanged: (value) => _formData.password = value,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) {
                  final password = value ?? '';
                  if (password.length < 6) {
                    return 'A senha possui menos de 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(_formData.isLogin ? 'Entrar' : 'Cadastrar'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _formData.toggleAuthMode();
                  });
                },
                child: Text(_formData.isLogin
                    ? 'Criar uma nova conta?'
                    : 'Já possui uma conta?'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
