import 'dart:async';
import 'dart:math';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/models/chat_message.dart';
import 'package:chat/core/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatFirebaseService implements ChatService {
  @override
  Stream<List<ChatMessage>> messagesStream() {
    final firebaseStore = FirebaseFirestore.instance;

    final snapshots = firebaseStore
        .collection('chat')
        .withConverter(
          fromFirestore: _fromFirestore,
          toFirestore: _toFirestore,
        )
        .snapshots();

    return Stream<List<ChatMessage>>.multi((controller) {
      snapshots.listen((snapshot) {
        List<ChatMessage> lista = snapshot.docs.map((doc) {
          return doc.data();
        }).toList();

        controller.add(lista);
      });
    });
  }

  @override
  Future<ChatMessage?> save(String text, ChatUser user) async {
    final firebaseStore = FirebaseFirestore.instance;

    final msg = ChatMessage(
      id: '',
      text: text,
      createdAt: DateTime.now(),
      userId: user.id,
      userName: user.name,
      userImageURL: user.imageUrl,
    );

    final docReference = await firebaseStore
        .collection('chat')
        .withConverter(fromFirestore: _fromFirestore, toFirestore: _toFirestore)
        .add(msg);

    final docSnapshot = await docReference.get();

    return docSnapshot.data()!;
  }

  ChatMessage _fromFirestore(DocumentSnapshot<Map<String, dynamic>> docSnapshot,
      SnapshotOptions? opt) {
    return ChatMessage(
      id: docSnapshot.id,
      text: docSnapshot['text'],
      createdAt: DateTime.parse(docSnapshot['createdAt']),
      userId: docSnapshot['userId'],
      userName: docSnapshot['userName'],
      userImageURL: docSnapshot['userImageURL'],
    );
  }

  Map<String, dynamic> _toFirestore(ChatMessage msg, SetOptions? opt) {
    return {
      "text": msg.text,
      "createdAt": msg.createdAt.toIso8601String(),
      "userId": msg.userId,
      "userName": msg.userName,
      "userImageURL": msg.userImageURL,
    };
  }
}
