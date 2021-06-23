import 'package:flutter/material.dart';
import 'package:one_person_twitter/app.dart';
import 'package:one_person_twitter/repository/user_repository.dart';
import 'repository/authentication_repository.dart';

void main() {
  runApp(App(
    authenticationRepository: AuthenticationRepository(),
    userRepository: UserRepository(),
  ));
}