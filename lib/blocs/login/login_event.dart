part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}


class LoginFormSubmitted extends LoginEvent{
  final String username;
  final String password;

  const LoginFormSubmitted({ required this.username, required this.password});

  @override
  List<Object> get props => [username, password];

  @override
  String toString() {
    return 'LoginFormSubmitted { username: $username, password: $password }';
  }
}