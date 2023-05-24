part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();
  
  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegistrationFailed extends RegisterState {
  
  final String message;
  const RegistrationFailed({ required this.message });


  @override
  List<Object> get props => [message];

  @override
  String toString() {
    return 'RegistrationFailed { error: $message }';
  }
}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final Map<String, String> verifiableRecord;

  const RegisterSuccess({ required this.verifiableRecord});

  @override
  List<Object> get props => [ verifiableRecord  ];
}


class VerificationFailed extends RegisterState {

  final String message;
  const VerificationFailed({required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() {
    return 'LoginFailed {error: $message}';
  }
  
}

class EmailVerified extends RegisterState {}

class PhoneVerified extends RegisterState {}

class ResentVerificationCode extends RegisterState {}
