import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:truvender/data/repositories/repositories.dart';

part 'kyc_event.dart';
part 'kyc_state.dart';

class KycBloc extends Bloc<KycEvent, KycState> {
  final KycRepository kycRepository = KycRepository();
  KycBloc() : super(KycInitial()) {
    on<SubmitBvnVerification>((event, emit) async {
      emit(KycLoading());
      try {
        await kycRepository.tierOneVerification(event.bvn);
        emit(BvnVerificationSuccess());
      } catch (e) {
        emit(KycFailed(error: e.toString()));
      }
    });
    on<SubmitKycVerificationRequest>((event, emit) async {
      emit(KycLoading());
      try {
        await kycRepository.tierTwoVerification(
          name: event.name,
          type: event.type,
          dateOfBirth: event.dateOfBirth,
          documentCode: event.documentCode,
          document: event.document,
        );
        emit(KycVerificationSuccess());
      } catch (e) {
        emit(KycFailed(error: e.toString()));
      }
    });
  }
}
