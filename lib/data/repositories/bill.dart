// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BillRepository {
  final Dio dioInstance;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  BillRepository({ required this.dioInstance});

  Future getVariations() async {
    try {
      var options = await _getRequestOptions();
      Response response = await dioInstance.get("/bills/variations", options: options);
      return response;
    } catch (err,stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $err stackTrace: $stacktrace");
      }
      throw Exception(err);
    }
  }

  Future localWallet() async {
    try {
      var options = await _getRequestOptions();
      Response response =
          await dioInstance.get("/wallet/all/?type=local", options: options);
      return response;
    } catch (err, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $err stackTrace: $stacktrace");
      }
      throw Exception(err);
    }
  }

  Future validateCustomer({
    required String item_code, 
    required String code, 
    required String customer,
  }) async {
    try {
      var options = await _getRequestOptions();
      Response response = await dioInstance.post(
          "/bills/customer/validations",
          data: {"item_code": item_code, "code": code, "customer": customer}, options: options);
      return response;
    } catch (err,stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $err stackTrace: $stacktrace");
      }
      throw Exception(err);
    }
  }
  

  Future payment({
    required String customer,
    required double amount,
    required String type,
    required String country,
    required String varation,
    required double fee,
  }) async {
    try {   
      var options = await _getRequestOptions();
      Response response = await dioInstance.post("/bills/payment/create", data: {
        "customer": customer,
        "amount": amount,
        "type": type,
        "country" : country,
        "varation": varation,
        "fee": fee,
      }, options: options);
      return response;
    } catch (err,stacktrace) {
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