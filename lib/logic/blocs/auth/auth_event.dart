part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthRegister extends AuthEvent {
  final String username;
  final String password;
  final String url;

  AuthRegister(this.username, this.password, this.url);
}

class AuthLogout extends AuthEvent {}

class AuthCheck extends AuthEvent {}
