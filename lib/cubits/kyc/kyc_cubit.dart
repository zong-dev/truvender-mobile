import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:truvender/blocs/app/app_bloc.dart';
import 'package:truvender/data/repositories/kyc.dart';
import 'package:truvender/utils/utils.dart';

part 'kyc_state.dart';

class KycCubit extends Cubit<KycState> {
  final AppBloc appBloc;
  KycCubit({ required this.appBloc }) : super(KycInitial());
  late KycRepository kycRepository = KycRepository(dioInstance: appBloc.dio );

  Future<void> submitTierOneVerification({
    required String bankNumber,
  }) async {
    emit(CreatingRequest());
    try {
      await kycRepository.tierOneVerification(bankNumber);
      appBloc.add(UserChanged());
      emit(TierOneVerification());
    } catch (e) {
      emit(RequestFailed(message: e.toString()));
    }
  }

  Future<void> submitKycDocumnet({
    required String name,
    required String type,
    required String dateOfBirth,
    required String documentCode,
    required File document,
  }) async {
    emit(CreatingRequest());
    try {
      var fileUploadRequest = await uploadFile(dioInstance: appBloc.dio, file: document);
      await kycRepository.tierTwoVerification(name: name, type: type, dateOfBirth: dateOfBirth, documentCode: documentCode, documentUrl: fileUploadRequest['url']);
      appBloc.add(UserChanged());
      emit(TierTwoVerification());
    } catch (e) {
      emit(RequestFailed(message: e.toString()));
    }
  }
}
