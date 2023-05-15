import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:truvender/blocs/app/app_bloc.dart';
import 'package:truvender/data/models/wallet.dart';
import 'package:truvender/data/repositories/repositories.dart';
import 'package:truvender/services/storage.dart';

part 'virtual_phone_state.dart';

class VirtualPhoneCubit extends Cubit<VirtualPhoneState> {

  final AppBloc appBloc;
  VirtualPhoneCubit({ required this.appBloc}) : super(VirtualPhoneInitial());
  late Wallet wallet;
  final StorageUtil storage = StorageUtil();
  late VirtualNumberRepository virtualNumberRepository = VirtualNumberRepository(dioInstance: appBloc.dio);

  Future<void> getAvailableTargets() async {
    try {
      emit(VRequestLoading());
       String targets = await storage.getStrVal("targets");
      if (targets.isEmpty || targets == null) {
        var request = await virtualNumberRepository.getTargets();
        await storage.setStrVal("targets", jsonEncode(request.data));
        emit(TargetsLoaded(
          targets: request.data,
        ));
      } else {
        emit(TargetsLoaded(targets: jsonDecode(targets)));
      }
    } catch (e) {
      emit(VerificationFailed(message: e.toString()));
    }
  }

  Future<void> buyTarget({ required String id}) async {
    try {
      emit(VRequestLoading());
      var request = await virtualNumberRepository.buyTarget(targetId: id);
      emit(TargetPurchaseSuccess(data: request.data ));
    } catch (e) {
      emit(VerificationFailed(message: e.toString()));
    }
  }

  Future<void> monitorTarget({ required String id}) async {
    try {
       emit(VRequestLoading());
       var request = await virtualNumberRepository.getVerificationDetails(id: id);
       if(request.data['sms'] && request.data['sms'].toString().isNotEmpty ){
         emit(VerificationSuccess(data: request.data));
       }
      //  Timer.periodic(Duration(seconds: 8), (timer) { 
      //    var reques
      //  });
    } catch (e) {
      emit(VerificationFailed(message: e.toString()));
    }
  }
}
