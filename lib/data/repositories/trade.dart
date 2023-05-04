import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TradeRepository {
  static String? baseUrl = dotenv.get('BASE_URL');
  static String endpoint = '$baseUrl';
  final Dio dioInstance;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  TradeRepository({required this.dioInstance});

  Future tradeGiftcard({
    required String asset,
    required double amount,
    required String type,
    required String rate,
    required int denomination,
    required int price,
    required bool isDefault,
    // required String reciept,
    required List images,
  }) async {
    try {
      var options = await _getRequestOptions();
      Response response = await dioInstance.post("$endpoint/trades/create/giftcard", data: {
            "asset" : asset, "amount": amount, "type": type, "rate": rate,
            "denomination": denomination,  "price": price, "isDefault": isDefault,
            "images": images,
          }, options: options);
      return response;
    } catch (err, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $err stackTrace: $stacktrace");
      }
      throw Exception(err);
    }
  }

  Future tradeCrypto({
    required String asset,
    required double amount,
    required String type,
    required String value,
  }) async {
    try {
      var options = await _getRequestOptions();
      Response response = await dioInstance.post("$endpoint/trades/create/crypto",
          data: {
            "asset" : asset, "amount": amount, "type": type, "value": value
          }, options: options);
      return response;
    } catch (err, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $err stackTrace: $stacktrace");
      }
      throw Exception(err);
    }
  }
  
  Future getWallet(String? id) async {
    try {
      var options = await _getRequestOptions();
      Response response = await dioInstance
          .get("$endpoint/wallet/all/?type=${id != null ? '' : 'local'}&asset=${id??''}", options: options);
      return response;
    } catch (err, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $err stackTrace: $stacktrace");
      }
      throw Exception(err);
    }
  }

  Future tradeSpendingCard({
    required String asset,
    required double amount,
    required String type,
    required Map<String, dynamic> images
  }) async {
    try {
      var options = await _getRequestOptions();
      Response response = await dioInstance
          .post("$endpoint/tradescreate/spending-cards", data: {
             "asset" : asset, "amount": amount, "type": type, "images": images
          }, options: options);
      return response;
    } catch (err, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $err stackTrace: $stacktrace");
      }
      throw Exception(err);
    }
  }

  Future tradeFunds({
    required String asset,
    required double amount,
    required String type,
    required String country,
    required String payableAccount,
    required String image,
  }) async {
    try {
      var options = await _getRequestOptions();
      Response response = await dioInstance.post(
          "$endpoint/tradescreate/funds",
          data: {
             "asset" : asset, "amount": amount, "type": type,
             "country": country, "payableAccount": payableAccount, "image": image
          },
          options: options);
      return response;
    } catch (err, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $err stackTrace: $stacktrace");
      }
      throw Exception(err);
    }
  }

  Future<Options> _getRequestOptions() async {
    final authToken = await storage.read(key: 'tru-token');
    return Options(headers: {"authorization": "Bearer $authToken"});
  }
}