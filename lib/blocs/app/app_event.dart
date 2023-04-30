part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}


class AppStarted extends AppEvent{}

class SignedIn extends AppEvent {
  final String token;
  const SignedIn({required this.token });

  @override
  List<Object> get props => [token];

  @override
  String toString() {
    return 'SignedIn(token: $token)';
  }
}


class UserChanged extends AppEvent {}


class SignOut extends AppEvent {}