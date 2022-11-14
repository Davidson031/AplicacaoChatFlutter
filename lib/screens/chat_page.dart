// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/auth/auth_service.dart';
import 'package:chat/core/services/chat/chat_mock_service.dart';
import 'package:chat/widgets/messages.dart';
import 'package:chat/widgets/new_message.dart';
import 'package:flutter/material.dart';

import '../core/models/chat_message.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Chat'),
        actions: [
          DropdownButton(
            onChanged: (value) {
              if (value == 'logout') {
                AuthService().logout();
              }
            },
            items: [
              DropdownMenuItem(
                value: 'logout',
                child: Container(
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app, color: Colors.red),
                      const SizedBox(width: 10),
                      Text('Sair')
                    ],
                  ),
                ),
              )
            ],
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
