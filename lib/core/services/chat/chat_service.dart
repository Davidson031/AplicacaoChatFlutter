import 'package:chat/core/models/chat_message.dart';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/chat/chat_firebase_service.dart';
import 'package:chat/core/services/chat/chat_mock_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ChatService {

  //stream de mensagens
  Stream<List<ChatMessage>> messagesStream();

  //salvar uma nova msg
  Future<ChatMessage?> save(String text, ChatUser user);

  factory ChatService(){
    return ChatFirebaseService();
  }

}