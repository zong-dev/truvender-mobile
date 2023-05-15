part of 'virtual_phone_cubit.dart';

abstract class VirtualPhoneState extends Equatable {
  const VirtualPhoneState();

  @override
  List<Object> get props => [];
}

class VRequestLoading extends VirtualPhoneState { }

class VirtualPhoneInitial extends VirtualPhoneState {}

class TargetsLoaded extends VirtualPhoneState {
  final dynamic targets;

  const TargetsLoaded({ required this.targets});

  @override
  List<Object> get props => [targets];
}


class TargetPurchaseSuccess extends VirtualPhoneState {
  final dynamic data;
  const TargetPurchaseSuccess({ required this.data });

  @override
  List<Object> get props => [data];
}

class VerifyingTarget extends VirtualPhoneState {}

class VerificationSuccess extends VirtualPhoneState{

  final dynamic data;
  const VerificationSuccess({ required this.data });

  @override
  List<Object> get props => [data];
}

class VerificationFailed extends VirtualPhoneState {
  final String message;
  const VerificationFailed({required this.message});

  @override
  List<Object> get props => [message];
}
