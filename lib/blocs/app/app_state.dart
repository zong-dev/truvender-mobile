part of 'app_bloc.dart';

abstract class AppState extends Equatable {
  const AppState();
  
  @override
  List<Object> get props => [];
}
class Initializing extends AppState {}
class Initialized extends AppState {}

class Authenticated extends AppState {
  
  final User user;
  final bool refreshed;

  const Authenticated({ required this.user, this.refreshed = false });

  @override
  List<Object> get props => [ user ];

}

class Unauthenticated extends AppState {}


class TransactionInitiated extends AppState {

  final Function onVerified;

  const TransactionInitiated({ required this.onVerified});

  @override
  List<Object> get props => [ onVerified ];

}

class Loading extends AppState {}

class OtpChallenge extends AppState {}
