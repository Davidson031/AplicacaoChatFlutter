import 'package:chat/core/services/auth/auth_service.dart';
import 'package:chat/core/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {

  String _enteredMessage ='';
  final _messageController = TextEditingController();

  Future<void> _sendMessage() async {

    final user = AuthService().currentUser;
    
    if(user != null){
      await ChatService().save(_enteredMessage, user);
      _messageController.clear();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: (value) {
              setState(() {
                _enteredMessage = value;
              });
            },
            controller: _messageController,
            decoration: const InputDecoration(labelText: 'Enviar Mensagem...'),
          ),
        ),
        IconButton(
          onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          icon: Icon(Icons.send),
        )
      ],
    );
  }
}
