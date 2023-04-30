import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WalletRepository {
  static String? baseUrl = dotenv.get('BASE_URL');
  static String endpoint = '$baseUrl/wallet';
  final Dio dioInstance;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  WalletRepository({required this.dioInstance});

  Future getWallet(String id) async {
    try {
      var options = await _getRequestOptions();
      Response response =
          await dioInstance.get("$endpoint/all/$id", options: options);
      return response;
    } catch (err, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $err stackTrace: $stacktrace");
      }
      throw Exception(err);
    }
  }

  Future initiateLocalFund(double amount) async {
    try {
      var options = await _getRequestOptions();
      Response response = await dioInstance.post("$endpoint/fund/initiate/",
          data: {"amount": amount}, options: options);
      return response;
    } catch (err, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $err stackTrace: $stacktrace");
      }
      throw Exception(err);
    }
  }

  Future completeLocalFund(String ref) async {
    try {
      var options = await _getRequestOptions();
      Response response = await dioInstance.post("$endpoint/funding/complete",
          data: {"ref": ref}, options: options);
      return response;
    } catch (err, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $err stackTrace: $stacktrace");
      }
      throw Exception(err);
    }
  }

  Future transfer({required String email, required double amount}) async {
    try {
      var options = await _getRequestOptions();
      Response response = await dioInstance.post("$endpoint/transfer",
          data: {"amount": amount, "email": email}, options: options);
      return response;
    } catch (err, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $err stackTrace: $stacktrace");
      }
      throw Exception(err);
    }
  }

  Future withdraw({required double amount}) async {
    try {
      var options = await _getRequestOptions();
      Response response = await dioInstance.post("$endpoint/withdraw",
          data: {"amount": amount}, options: options);
      return response;
    } catch (err, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $err stackTrace: $stacktrace");
      }
      throw Exception(err);
    }
  }

  Future cryptoTransfer(
      {required double amount,
      required String wallet,
      required String value,
      required String address}) async {
    try {
      var options = await _getRequestOptions();
      Response response = await dioInstance.post("$endpoint/crypto/transfer",
          data: {
            "amount": amount,
            "value": value,
            "wallet": wallet,
            "address": address
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
