import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';


class UserRepository {
  User _user;

  Future<User> getUser() async {
    if (_user != null) return _user;
    return Future.delayed(
      const Duration(milliseconds: 300),
      () => _user = FirebaseAuth.instance.currentUser,
    );
  }
}
