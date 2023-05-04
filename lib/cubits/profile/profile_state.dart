part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProcessingRequest extends ProfileState {}

class UploadingAvatar extends ProfileState {}

class RequestSuccess extends ProfileState {
  final dynamic responseData;
  final bool isSubProccess;

  const RequestSuccess({ this.responseData, this.isSubProccess = false });

  @override
  List<Object> get props => [ responseData ];
}

class RequestFailed extends ProfileState {
  final String message;

  const RequestFailed({required this.message});

  @override
  List<Object> get props => [message];

}