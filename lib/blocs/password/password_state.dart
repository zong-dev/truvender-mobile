part of 'password_bloc.dart';

abstract class PasswordState extends Equatable {
  const PasswordState();
  
  @override
  List<Object> get props => [];
}

class PasswordInitial extends PasswordState {}

class PasswordResetComplete extends PasswordState {}

class InstructionSent extends PasswordState {

  final String sentTo;

  const InstructionSent({required this.sentTo});

  @override
  List<Object> get props => [ sentTo ];

}

class PasswordLoading extends PasswordState {}

class PasswordFailed extends PasswordState {
  final String error;

  const PasswordFailed({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return "PasswordFailed {error: $error}";
  }
}
