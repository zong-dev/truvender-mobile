import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:truvender/blocs/app/app_bloc.dart';
import 'package:truvender/data/models/models.dart';
import 'package:truvender/data/repositories/repositories.dart';
import 'package:truvender/services/services.dart';
import 'package:truvender/utils/utils.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AppBloc appBloc;
  ProfileCubit({required this.appBloc}) : super(ProfileInitial());

  late AccountRepository accountRepository =
      AccountRepository(dioInstance: appBloc.dio);
  final StorageUtil storage = StorageUtil();
  
  Future<void> dashboard() async {
    emit(ProcessingRequest());
    try {
      var request = await accountRepository.accountData();
      emit(RequestSuccess(responseData: request.data));
    } catch (e) {
      emit(RequestFailed(message: e.toString()));
    }
  }

  Future<void> banks() async {
    emit(ProcessingRequest());
    try {
      String bankList = await storage.getStrVal("banks");
      if(bankList.isEmpty){
        var request = await accountRepository.getBanks();
        await storage.setStrVal("banks", jsonEncode(request.data));
        emit(RequestSuccess(responseData: request.data));
      }else {
        emit(RequestSuccess(responseData: jsonDecode(bankList)));
      }
    } catch (e) {
      emit(RequestFailed(message: e.toString()));
    }
  }

  Future<void> profile() async {
    emit(ProcessingRequest());
    try {
      var request = await accountRepository.getProfile();
      emit(RequestSuccess(responseData: request.data));
    } catch (e) {
      emit(RequestFailed(message: e.toString()));
    }
  }

  Future<void> wallets() async {
    emit(ProcessingRequest());
    try {
      var request = await accountRepository.getWallets();
      List responseData = request.data.map((walletData) {
        var asset = walletData['type'] == 1 && walletData['asset'] != null
            ? Asset.fromJson(walletData['asset'])
            : null;
        Map<String, dynamic> data = {
          "balance": walletData['balance'],
          "type": walletData['type'],
          "_id": walletData['_id'],
          "asset": asset,
          "currency": appBloc.authenticatedUser.currency
        };
        var wallet = Wallet.fromJson(data);
        return wallet;
      }).toList();

      emit(RequestSuccess(responseData: responseData));
    } catch (e) {
      emit(RequestFailed(message: e.toString()));
    }
  }

  Future<void> transactions({
    required String walletId,
    int page = 1,
    String dateFrom = '',
    String dateTo = '',
  }) async {
    emit(ProcessingRequest());
    try {
      var request = await accountRepository
          .getTransactions(walletId: walletId, selector: {
        "page": page,
        "dateFrom": dateFrom,
        "dateTo": dateTo,
      });

      var response = request.data;
      List transactions = response['docs'].map((transactionRecord) {
        return Transaction.fromJson({
          ...transactionRecord,
          "currency": appBloc.authenticatedUser.currency
        });
      }).toList();

      response['docs'] = transactions;

      emit(RequestSuccess(responseData: response, isSubProccess: true));
    } catch (e) {
      emit(RequestFailed(message: e.toString()));
    }
  }

  Future<void> trades({
    int page = 1,
    String dateFrom = '',
    String dateTo = '',
    String type = '',
  }) async {
    emit(ProcessingRequest());
    try {
      var request = await accountRepository.getTrades(selector: {
        "page": page,
        "dateFrom": dateFrom,
        "dateTo": dateTo,
        "type": type
      });

      var response = request.data;
      List trades = response['docs'].map((transactionRecord) {
        return Trade.fromJson({
          ...transactionRecord,
          "currency": appBloc.authenticatedUser.currency
        });
      }).toList();

      response['docs'] = trades;

      emit(RequestSuccess(responseData: response));
    } catch (e) {
      emit(RequestFailed(message: e.toString()));
    }
  }

  Future<void> updateProfile({
    required String country,
    required String state,
    required String postalCode,
    required String currency,
  }) async {
    emit(ProcessingRequest());
    try {
      var request = await accountRepository.updateProfile(
          state: state,
          country: country,
          postalCode: postalCode,
          currency: currency);
      if (request.statusCode == 200) {
        emit(RequestSuccess(responseData: request.data));
      }
    } catch (e) {
      emit(RequestFailed(message: e.toString()));
    }
  }

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    emit(ProcessingRequest());
    try {
      var request = await accountRepository.changePassword(
          currentPassword: currentPassword, newPassword: newPassword);
      if (request.statusCode == 200) {
        emit(RequestSuccess(responseData: request.data));
      }
    } catch (e) {
      emit(RequestFailed(message: e.toString()));
    }
  }

  Future<void> updatOrCreatePin({
    String? currentPin,
    required String newPin,
  }) async {
    emit(ProcessingRequest());
    try {
      var request = await accountRepository.createOrUpdatePin(
          currentPin: currentPin ?? '', newPin: newPin);
      if (request.statusCode == 200) {
        emit(RequestSuccess(responseData: request.data));
      }
    } catch (e) {
      emit(RequestFailed(message: e.toString()));
    }
  }

  Future<void> updateSetting({
    required int notifyType,
    required bool requireOtp,
  }) async {
    emit(ProcessingRequest());
    try {
      var request = await accountRepository.updateSetting(
          requireOtp: requireOtp, notifyType: notifyType);
      emit(RequestSuccess(responseData: request.data));
    } catch (e) {
      emit(RequestFailed(message: e.toString()));
    }
  }

  Future<void> changeAvatar({required File image}) async {
    emit(ProcessingRequest());
    try {
      emit(UploadingAvatar());
      var uploadRequest = await uploadFile(dioInstance: appBloc.dio, file: image);
      var request = await accountRepository.changeAvatar(imgUrl: uploadRequest['url']);
      emit(RequestSuccess(responseData: request.data));
    } catch (e) {
      emit(RequestFailed(message: e.toString()));
    }
  }

  Future<void> addAccount({
    required String accountBank,
    required String accountNumber,
    required String bankName,
  }) async {
    emit(ProcessingRequest());
    try {
      var request = await accountRepository.addWithdrawAccount(
          accountBank: accountBank,
          accountNumber: accountNumber,
          bankName: bankName);
      if (request.statusCode == 200) {
        appBloc.add(UserChanged());
        emit(RequestSuccess(responseData: request.data));
      }
    } catch (e) {
      emit(RequestFailed(message: e.toString()));
    }
  }

  Future<void> validateAccount({
    required String account,
    required String bank,
  }) async {
    emit(ProcessingRequest());
    try {
      var request = await accountRepository.resolveAccount(
        account: account,
        bank: bank,
      );
      emit(RequestSuccess(responseData: request.data['data'], isSubProccess: true));
    } catch (e) {
      emit(const RequestFailed(message: 'Account is not valid'));
    }
  }
}
