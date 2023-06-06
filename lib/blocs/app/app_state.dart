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

class Loading extends AppState {}

class OtpChallenge extends AppState {}

class AccountVerification extends AppState {
  final User user;
  const AccountVerification({ required this.user});
  @override
  List<Object> get props => [user];
}

class KycVerification extends AppState {
  final User user;
  final String path;
  const KycVerification({ required this.user, required this.path});
}


class Authenticating extends AppState {}

class AccountVerified extends AppState {}

class ValidationFailed extends AppState {}
