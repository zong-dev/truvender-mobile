import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AccountRepository {
  static String flwSecret = dotenv.get("FLW_SECRET_KEY");
  final Dio dioInstance;

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  AccountRepository({required this.dioInstance});

  Future getProfile() async {
    try {
      var options = await _getRequestOptions();
      Response response = await dioInstance.get("/profile", options: options);
      return response;
    } catch (err, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $err stackTrace: $stacktrace");
      }
      throw Exception(err);
    }
  }

  Future getBanks() async {
    try {
      var options = await _getRequestOptions();
      Response response =
          await dioInstance.get("/transactions/banks", options: options);
      return response;
    } catch (err, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $err stackTrace: $stacktrace");
      }
      throw Exception(err);
    }
  }

  Future getWallets() async {
    try {
      var options = await _getRequestOptions();
      Response response = await dioInstance.get("/wallet/all", options: options);
      return response;
    } catch (err, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $err stackTrace: $stacktrace");
      }
      throw Exception(err);
    }
  }

  Future getTransactions({required String walletId, required Map<String, dynamic> selector}) async {
    try {
      var options = await _getRequestOptions();
      Response response =
          await dioInstance.get("/transactions/by-wallet/$walletId", queryParameters: selector, options: options);
      return response;
    } catch (err, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $err stackTrace: $stacktrace");
      }
      throw Exception(err);
    }
  }

  Future getTrades({required Map<String, dynamic> selector}) async {
    try {
      var options = await _getRequestOptions();
      Response response = await dioInstance.get(
          "/trades",
          queryParameters: selector,
          options: options
      );
      return response;
    } catch (err, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $err stackTrace: $stacktrace");
      }
      throw Exception(err);
    }
  }

  Future accountData() async {
    try {
    var options = await _getRequestOptions();
    Response response = await dioInstance.get("/account/dashboard", options: options);
    return response;
    } catch (err, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $err stackTrace: $stacktrace");
      }
      throw Exception(err);
    }
  }

  Future addWithdrawAccount(
      {required String accountBank,
      required String accountNumber,
      required String bankName}) async {
    try {
      var options = await _getRequestOptions();
      Map requestData = {
        "account_number": accountNumber,
        "bank_name": bankName,
        "account_bank": accountBank
      };
      Response response = await dioInstance
          .post("/profile/withdraw-account/add", data: requestData, options: options);
      return response;
    } catch (err, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $err stackTrace: $stacktrace");
      }
      throw Exception(err);
    }
  }

  Future resolveAccount({ required String account, required String bank}) async {
    try {
      Map requestData = { "account_bank": bank, "account_number": account };
      Dio newDio = Dio();
      Response response = await newDio.post("https://api.flutterwave.com/v3/accounts/resolve", data: requestData, options: Options(headers: {
        "Authorization": flwSecret,
      }));
      return response;
    } catch (err, stacktrace) {
      if (kDebugMode) {
        print(err);
        print("Exception occured: $err stackTrace: $stacktrace");
      }
      throw Exception(err);
    }
  }


  Future updateSetting({
    required bool requireOtp,
    required int notifyType,
  }) async {
    try {
       var options = await _getRequestOptions();
      Response response =
          await dioInstance.post("/profile/settings/update", data: {
        "notifyType": notifyType,
        "requireOtp": requireOtp,
      }, options: options);
      return response;
    } catch (err, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $err stackTrace: $stacktrace");
      }
      throw Exception(err);
    }
  }

  Future changeAvatar({
    required String imgUrl,
  }) async {
    try {
      var options = await _getRequestOptions();
      Response response =
          await dioInstance.post("/profile/update-avatar", data: {
          "imgUrl": imgUrl,
        }, options: options
      );
      return response;
    } catch (err, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $err stackTrace: $stacktrace");
      }
      throw Exception(err);
    }
  }

  Future createOrUpdatePin({
    required String? currentPin,
    required String newPin,
  }) async {
    try {
      var options = await _getRequestOptions();
      Response response = await dioInstance.post(
          "/profile/security/update-pin",
          data: {"currentPin": currentPin ?? '', "newPin": newPin}, options: options);
      return response;
    } catch (err, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $err stackTrace: $stacktrace");
      }
      throw Exception(err);
    }
  }

  Future changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      var options = await _getRequestOptions();
      Response response = await dioInstance
          .post("/profile/security/password", data: {
        "currentPassword": currentPassword,
        "newPassword": newPassword
      }, options: options);
      return response;
    } catch (err, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $err stackTrace: $stacktrace");
      }
      throw Exception(err);
    }
    
  }

  Future updateProfile({
    required String state,
    required String country,
    required String postalCode,
    required String currency,
  }) async {
    try {
      var options = await _getRequestOptions();
      Response response =
          await dioInstance.post("/profile/security/password", data: {
        "state": state,
        "country": country,
        "currency": currency,
        "postalCode": postalCode
      }, options: options);
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
