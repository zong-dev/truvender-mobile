part of 'kyc_bloc.dart';

abstract class KycEvent extends Equatable {
  const KycEvent();

  @override
  List<Object> get props => [];
}

class SubmitBvnVerification extends KycEvent {
  final String bvn;

  const SubmitBvnVerification({required this.bvn});

  @override
  // TODO: implement props
  List<Object> get props => [bvn];

  @override
  String toString() {
    return 'BvnVerification {bvn: $bvn}';
  }
}

class SubmitKycVerificationRequest extends KycEvent {
  final String name;
  final String type;
  final String dateOfBirth;
  final String documentCode;
  final File document;

  const SubmitKycVerificationRequest(
      {required this.name,
      required this.type,
      required this.dateOfBirth,
      required this.documentCode,
      required this.document});

  @override
  // TODO: implement props
  List<Object> get props => [name, type, dateOfBirth, document, documentCode];

  @override
  String toString() {
    // TODO: implement toString
    return 'SubmitKycVerificationRequest { name: $name, type: $type, documentCode: $documentCode, dateOfBirth: $dateOfBirth }';
  }
}
