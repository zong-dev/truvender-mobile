import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:truvender/blocs/app/app_bloc.dart';
import 'package:truvender/data/models/models.dart';
import 'package:truvender/data/repositories/repositories.dart';
import 'package:truvender/utils/utils.dart';

part 'trade_state.dart';

class TradeCubit extends Cubit<TradeState> {
  final AppBloc appBloc;
  TradeCubit({required this.appBloc}) : super(TradeInitial());
  

  late TradeRepository tradeRepository =
      TradeRepository(dioInstance: appBloc.dio);

  late ExchangeRepository exchangeRepository =
      ExchangeRepository(dioInstance: appBloc.dio);

  Future<void> getWallet({String? id}) async {
    emit(PerformingTrade());
    try {
      var request = await tradeRepository.getWallet(id);
      var asset = request.data['type'] == 1 && request.data['asset'] != null
          ? Asset.fromJson(request.data['asset'])
          : null;
        Map<String, dynamic> walletData = {
          ...request.data,
          "currency": appBloc.authenticatedUser.currency,
          "asset": asset,
        };
      var wallet = Wallet.fromJson(walletData);
      emit(WalletLoaded(wallet: wallet));
    } catch (e) {
      emit(ProcessFailed(message: e.toString()));
    }
  }


  Future<void> submitGiftcardTrade({
    required String asset,
    required double amount,
    required String type,
    required String rate,
    required int denomination,
    required int price,
    required bool isDefault,
    required List images,
  }) async {
    emit(PerformingTrade());
    try {
      var uploadedImages = [];
      for (var image in images) {
        var uploadRequest = await uploadFile(dioInstance: appBloc.dio, file: image['file']);
        uploadedImages.add({ "url": uploadRequest['url'], "type": image['type']});
      }
      
      var request = await tradeRepository.tradeGiftcard(
        asset: asset,
        amount: amount,
        type: type,
        rate: rate,
        denomination: denomination,
        price: price,
        isDefault: isDefault,
        // reciept: reciept,
        images: uploadedImages,
      );
      var response = request.data;
      if (response['status'] == true && response['data'] != null) {
        var trade = Trade.fromJson(response['data']);
        emit(TradeSuccess(type: "giftcard", trade: trade));
      } else {
        emit(TradeFailed(message: response['message'], type: "giftcard"));
      }
    } catch (e) {
      emit(ProcessFailed(message: e.toString()));
    }
  }

  Future<void> submitCryptoTrade({
    required String asset,
    required double amount,
    required String type,
    required String value,
  }) async {
    emit(PerformingTrade());
    try {
      var request = await tradeRepository.tradeCrypto(
        asset: asset,
        amount: amount,
        type: type,
        value: value,
      );
      var response = request.data;
      if (response['status'] == true && response['data'] != null) {
        var trade = Trade.fromJson(response['data']);
        emit(TradeSuccess(type: "crypto", trade: trade));
      } else {
        emit(TradeFailed(message: response['message'], type: "crypto"));
      }
    } catch (e) {
      emit(ProcessFailed(message: e.toString()));
    }
  }

  Future<void> submitFundsTrade({
    required String asset,
    required double amount,
    required String type,
    required String country,
    required String payableAccount,
    required String image,
  }) async {
    emit(PerformingTrade());
    try {
      var request = await tradeRepository.tradeFunds(
        asset: asset,
        amount: amount,
        type: type,
        country: country,
        payableAccount: payableAccount,
        image: image,
      );
      var response = request.data;
      if (response['status'] == true && response['data'] != null) {
        var trade = Trade.fromJson(response['data']);
        emit(TradeSuccess(type: "funds", trade: trade));
      } else {
        emit(TradeFailed(message: response['message'], type: "funds"));
      }
    } catch (e) {
      emit(ProcessFailed(message: e.toString()));
    }
  }

  Future<void> submitSpendingCardTrade(
      {required String asset,
      required double amount,
      required String type,
      required Map<String, dynamic> images}) async {
    emit(PerformingTrade());
    try {
      var request = await tradeRepository.tradeSpendingCard(
        asset: asset,
        amount: amount,
        type: type,
        images: images,
      );
      var response = request.data;
      if (response['status'] == true && response['data'] != null) {
        var trade = Trade.fromJson(response['data']);
        emit(TradeSuccess(type: "spending-card", trade: trade));
      } else {
        emit(TradeFailed(message: response['message'], type: "spending-card"));
      }
    } catch (e) {
      emit(ProcessFailed(message: e.toString()));
    }
  }

  Future<void> convertRateToLocalCurrency({required double rate}) async {
    emit(ConvertingRate());
    try {
      var request = await exchangeRepository.getCurrencyRate(amount: rate);
      emit(RateConverted(rate: double.parse(request.data)));
    } catch (e) {
      emit(ProcessFailed(message: e.toString()));
    }
  }

  Future<void> cryptoValue(
      {required double amount, required String asset}) async {
    emit(ConvertingRate());
    try {
      var request = await exchangeRepository.getCryptoValue(
          amount: amount, currency: asset);
      emit(
          RateConverted(rate: double.parse(request.data), isCryptoValue: true));
    } catch (e) {
      emit(ProcessFailed(message: e.toString()));
    }
  }
}
