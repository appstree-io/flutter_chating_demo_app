import 'package:chat_app/models/usersmodel.dart';
import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  ChatUser? _chatUser;

  setChatUser(ChatUser user) {
    _chatUser = user;
    notifyListeners();
  }

  ChatUser? get currentChatUser => _chatUser;
}
