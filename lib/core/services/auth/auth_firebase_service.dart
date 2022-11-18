// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'package:chat/core/models/chat_user.dart';
import 'dart:io';
import 'package:chat/core/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthFirebaseService implements AuthService {
  static ChatUser? _currentUser;

  static final _userStream = Stream<ChatUser?>.multi((controller) async {
    final authChanges = FirebaseAuth.instance.authStateChanges();

    await for (final user in authChanges) {
      _currentUser = user == null ? null : _toChatUser(user);
      controller.add(_currentUser);
    }
  });

  static final authChanges = FirebaseAuth.instance.authStateChanges();

  Stream<ChatUser?> get userChanges {
    return _userStream;
  }

  @override
  ChatUser? get currentUser {
    return _currentUser;
  }

  @override
  Future<void> login(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() async {
    FirebaseAuth.instance.signOut();
  }

  Future<String?> _uploadUserImage(File? image, String imageName) async {

    if (image == null) return null;

    final storage = FirebaseStorage.instance;
    final imageRef = storage.ref().child('user_images').child(imageName);
    await imageRef.putFile(image).whenComplete(() {});
    return await imageRef.getDownloadURL();

  }

  @override
  Future<void> signUp(
      String nome, String email, String password, File? image) async {
    final auth = FirebaseAuth.instance;

    UserCredential credentials = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credentials.user == null) return;


    //upload da foto do usuario no firestore
    final imageName = '${credentials.user!.uid}.jpg';
    final imageURL = await _uploadUserImage(image, imageName);

    //atualizando os atributos do usuário
    await credentials.user?.updateDisplayName(nome);
    await credentials.user?.updatePhotoURL(imageURL);

    //salvar user no firestore
    await _saveChatUser(_toChatUser(credentials.user!, imageURL));

  }

  static ChatUser _toChatUser(User user, [String? imageURL]) {
    return ChatUser(
      id: user.uid,
      name: user.displayName ?? user.email!.split('@')[0],
      email: user.email!,
      imageUrl: imageURL ?? user.photoURL ?? 'assets/images/avatar.png',
    );
  }

  Future<void> _saveChatUser(ChatUser user) async {

    final store = FirebaseFirestore.instance;
    final docRef = store.collection('users').doc(user.id);

    return docRef.set({
      'name' : user.name,
      'email' : user.email,
      'imageURL' : user.imageUrl,
    });
  }
}
