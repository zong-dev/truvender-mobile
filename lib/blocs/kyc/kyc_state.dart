part of 'kyc_bloc.dart';

abstract class KycState extends Equatable {
  const KycState();
  
  @override
  List<Object> get props => [];
}

class KycInitial extends KycState {}

class KycLoading extends KycState {}

class KycFailed extends KycState {
  final String error;

  const KycFailed({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    // TODO: implement toString
    return "KycFailed {error: $error}";
  }
}

class BvnVerificationSuccess extends KycState {}

class KycVerificationSuccess extends KycState {}
