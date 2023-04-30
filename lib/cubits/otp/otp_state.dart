part of 'otp_cubit.dart';

abstract class OtpState extends Equatable {
  const OtpState();

  @override
  List<Object> get props => [];
}

class OtpInitial extends OtpState {}

class OtpError extends OtpState{
  final String message;
  OtpError({ required this.message });

  @override
  List<Object> get props => [message];
}

class OtpVerified extends OtpState{}

class ResentOtp extends OtpState {}

class ProcessingOtpRequest extends OtpState {}

class OtpRequestFailed extends OtpState {}
