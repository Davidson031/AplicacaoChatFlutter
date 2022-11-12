import 'dart:async';
import 'dart:math';
import 'package:chat/core/models/chat_user.dart';
import 'dart:io';
import 'package:chat/core/services/auth/auth_service.dart';

class AuthMockService implements AuthService {
  static ChatUser? _currentUser;

  
  static Map<String, ChatUser> _users = {};
  static MultiStreamController<ChatUser?>? _controller;

  static final _userStream = Stream<ChatUser?>.multi((controller) {
    _controller = controller;
    _updateUser(null);
  });

  Stream<ChatUser?> get userChanges {
    return _userStream;
  }

  @override
  ChatUser? get currentUser {
    return _currentUser;
  }

  @override
  Future<void> login(String email, String password) async {
    _updateUser(_users[email]);
  }

  @override
  Future<void> logout() async {
    _updateUser(null);
  }

  @override
  Future<void> signUp(String nome, String email, String password, File? image) async {

    final newUser = ChatUser(
      id: Random().nextDouble().toString(),
      name: nome,
      email: email,
      imageUrl: image?.path ?? '/assets/images/...',
    );

    _users.putIfAbsent(email, () => newUser);
    _updateUser(newUser);

  }

  static void _updateUser(ChatUser? user) {
    _currentUser = user;
    _controller?.add(_currentUser);
  }
}
