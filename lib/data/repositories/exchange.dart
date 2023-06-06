import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ExchangeRepository {
  final Dio dioInstance;

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  ExchangeRepository({required this.dioInstance});

  Future getCurrencyRate({required double amount}) async {
    try {
      var options = await _getRequestOptions();
      Response response = await dioInstance
          .post("/get-rate", data: {"amount": amount}, options: options);
      return response;
    } catch (err, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $err stackTrace: $stacktrace");
      }
      throw Exception(err);
    }
  }

  Future getCryptoValue(
      {required double amount, required String currency}) async {
    try {
      var options = await _getRequestOptions();
      Response response = await dioInstance.post("/crypto/value",
          data: {"amount": amount, "currency": currency}, options: options);
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
