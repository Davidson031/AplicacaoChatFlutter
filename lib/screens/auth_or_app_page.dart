import 'package:chat/core/services/auth/auth_mock_service.dart';
import 'package:chat/core/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import '../core/models/chat_user.dart';
import 'auth_page.dart';
import 'chat_page.dart';
import 'loading_page.dart';

class AuthOrAppPage extends StatelessWidget {
  const AuthOrAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<ChatUser?>(
        stream: AuthMockService().userChanges,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingPage();
          } else {
            return snapshot.hasData ? const ChatPage() : const AuthPage();
          }
        },
      ),
    );
  }
}
