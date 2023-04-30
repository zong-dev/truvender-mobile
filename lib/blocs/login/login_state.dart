part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();
  
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSucess extends LoginState {
  final String token;
  const LoginSucess({ required this.token});
  
  @override
  List<Object> get props => [token];
}

class LoginFailed extends LoginState {

  final String message;
  const LoginFailed({required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() {
    return 'LoginFailed {error: $message}';
  }
  
}

// class 