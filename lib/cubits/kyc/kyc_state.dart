part of 'kyc_cubit.dart';

abstract class KycState extends Equatable {
  const KycState();

  @override
  List<Object> get props => [];
}

class KycInitial extends KycState {}


class CreatingRequest extends KycState {}

class RequestFailed extends KycState {
  final String message;

  const RequestFailed({required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() {
    return "RequestFailed {error: $message}";
  }
}

class TierOneVerification extends KycState {}

class TierTwoVerification extends KycState {}
