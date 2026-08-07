part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class UserSignUp extends AuthEvent {
  final String name;
  final String email;
  final String password;

  UserSignUp({required this.name, required this.email, required this.password});
}

final class UserSignIn extends AuthEvent {
  final String email;
  final String password;

  UserSignIn({required this.email, required this.password});
}

final class AuthIsUserLoggedIn extends AuthEvent {}
