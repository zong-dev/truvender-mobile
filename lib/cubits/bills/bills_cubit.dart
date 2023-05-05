// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:truvender/blocs/app/app_bloc.dart';
import 'package:truvender/data/models/wallet.dart';
import 'package:truvender/data/repositories/repositories.dart';
import 'package:truvender/services/services.dart';

part 'bills_state.dart';

class BillsCubit extends Cubit<BillsState> {
  final AppBloc appBloc;
  BillsCubit({ required this.appBloc }) : super(BillsInitial());

  late BillRepository billRepository = BillRepository(dioInstance: appBloc.dio);
  late Wallet wallet;
  final StorageUtil storage = StorageUtil();
  

  Future<void> loadVariations() async{
    emit(RequestLoading());
    try {
      String variations = await storage.getStrVal("variations");
      if(variations.isEmpty || variations == null){
        var request = await billRepository.getVariations();
        await storage.setStrVal("variations", jsonEncode(request.data));
        emit(VariationLoaded(variations: request.data, ));
      }else{
        emit(VariationLoaded(variations: jsonDecode(variations) ));
      }
    } catch (e) {
      emit(BillRequestFailed(message: e.toString()));
    }
  }

  Future<void> getWallet() async {
    emit(RequestLoading());
    try {
        var request = await billRepository.localWallet();
        var asset = request.data['type'] == 1 && request.data['asset'] != null
            ? Asset.fromJson(request.data['asset'])
            : null;
        Map<String, dynamic> walletData = {
          ...request.data,
          "currency": appBloc.authenticatedUser.currency,
          "asset": asset,
        };
        wallet = Wallet.fromJson(walletData);
        
        emit(WalletLoaded(wallet: wallet ));
    } catch (e) {
      emit(BillRequestFailed(message: e.toString()));
    }
  }

  Future<void> validateCustomer({
    required String itemCode,
    required String code,
    required String customer,
  }) async {
    emit(RequestLoading());
    try {
      var request = await billRepository.validateCustomer(item_code: itemCode, code: code, customer: customer);
      var response = request.data;
      if(response['status'] == false && response['verificationData'] == null){
        emit(VerificationFailed());
      }else {
        emit(CustomerVerified(customerData: response['verificationData']));
      }
    } catch (e) {
      emit(VerificationFailed());
    }
  }

  Future<void> makePayment({
    required String customer,
    required double amount,
    required String type,
    required String country,
    required String varation,
    required double fee,
  }) async {
    emit(RequestLoading());
    try {
      if(varation =="airtime" && amount > 20000){
        emit(const BillRequestFailed(message: "Maximum airtime limit exceeded"));
      }else {
        if(wallet != null && wallet.balance > (amount + fee )){
          var request = await billRepository.payment(customer: customer, amount: amount, type: type, country: country, varation: varation, fee: fee);
          emit(PaymentSuccess(responseData: request.data));
        }else if(wallet == null){
          emit(const BillRequestFailed(message: "Wallet record could not be loaded"));
        } else if (wallet.balance < (amount + fee)) {
          emit(const BillRequestFailed(message: "Insufficient wallet balance"));
        }
      }
    } catch (e) {
      emit(BillRequestFailed(message: e.toString()));
    }
  }

}
