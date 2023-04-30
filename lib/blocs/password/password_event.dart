part of 'password_bloc.dart';

abstract class PasswordEvent extends Equatable {
  const PasswordEvent();

  @override
  List<Object> get props => [];
}


class EmailSubmitted extends PasswordEvent {
  final String email;

  const EmailSubmitted({ required this.email});

  @override
  List<Object> get props => ['email'];
  
}


class PasswordResetSubmitted extends PasswordEvent{
  final String email;
  final String password;
  final String token;

  const PasswordResetSubmitted({required this.email, required this.password, required this.token});

  @override
  List<Object> get props => [email, password, token ];
}


