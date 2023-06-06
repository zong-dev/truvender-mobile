import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  final Dio dioInstance;

  AuthRepository({required this.dioInstance});

  // Tokenomics
  Future<bool> isAuthenticated() async {
    var storedToken = await storage.read(key: 'tru-token');
    return storedToken != null ? true : false;
  }

  persistToken(String tkn) async {
    await storage.write(key: 'tru-token', value: tkn);
  }

  resetToken() async {
    await storage.delete(key: 'tru-token');
    await storage.deleteAll();
  }

  Future signIn(String username, String password) async {
    try {
      var response = await dioInstance.post("/auth/signin",
          data: {"username": username, "password": password});
      return response;
    } catch (err, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $err stackTrace: $stacktrace");
      }
      throw Exception(err);
    }
  }

  checkDuplicateRecords(
      {required String email,
      required String phone,
      required String username}) async {
    try {
      Response response =
          await dioInstance.post("/auth/active-record", data: {
        'records': {
          'email': email,
          'phone': phone,
          'username': username,
        }
      });
      return response;
    } catch (err, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $err stackTrace: $stacktrace");
      }
      throw Exception(err);
    }
  }

  signUp({
    required String email,
    required String phone,
    required String username,
    required String password,
    required String? country,
    required String? currency,
    String? referrer,
  }) async {
    try {
      Response response =
          await dioInstance.post("/auth/signin", data: {
        "username": username,
        "password": password,
        "email": email,
        "phone": phone,
        "country": country ?? '',
        "currency": currency ?? '',
        "referrer": referrer!.isNotEmpty ? referrer : ''
      });
      return response;
    } catch (err, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $err stackTrace: $stacktrace");
      }
      throw Exception(err);
    } 
  }

  getUser() async {
    try {
      var options = await _getRequestOptions();
      var response = await dioInstance.get(
        "/account",
        options:options,
      );
      return response;
    } catch (err, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $err stackTrace: $stacktrace");
      }
      throw Exception(err);
    }
  }

  /* =========== Account Verification (Email and Phone) =================== */
  resendVerificationToken(String type) async {
    var options = await _getRequestOptions();
    Response response = await dioInstance.post(
      "/auth/resend-token/$type",
      data: {},
      options: options,
    );
    return response.data;
  }

  verifyAccount(String vType, String token) async {
    var options = await _getRequestOptions();
    Response response = await dioInstance.post(
      "/auth/verify-account",
      data: {"token": token, "type": vType},
      options:options,
    );
    return response;
  }

  /* =========== Password Reset =================== */
  forgotPassword(String email) async {
    try {
      Response response = await dioInstance.post(
        "/auth/password/send-instruction",
        data: {"email": email},
      );
      return response;
    } catch (err, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $err stackTrace: $stacktrace");
      }
      throw Exception(err);
    }
  }

  resetPassword(
      {required String email,
      required String token,
      required String password}) async {
    try {
      Response response = await dioInstance.post(
        "/auth/password/reset",
        data: {"email": email, 'token': token, "password": password},
      );
      return response.data;
    } catch (err, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $err stackTrace: $stacktrace");
      }
      throw Exception(err);
    }
  }

  /* =========== OwnerValidation =================== */
  verificationChallenge(String type, String val) async {
    try {
      var options = await _getRequestOptions();
      Response response = await dioInstance.post(
        "/auth/verification-challenge",
        data: {"type": type, 'value': val},
        options:options,
      );
      return response;
    } catch (err, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $err stackTrace: $stacktrace");
      }
      throw Exception(err);
    }
  }

  /* =========== One Time Password =================== */
  verifyOTP(String token) async {
    try {
      var options = await _getRequestOptions();
      Response response = await dioInstance.post(
        "/auth/otp-challenge",
        data: {"token": token},
        options: options,
      );
      return response;
    } catch (err, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $err stackTrace: $stacktrace");
      }
      throw Exception(err);
    }
  }

  sendOTP() async {
    try {
      var options = await _getRequestOptions();
      Response response = await dioInstance.post(
        "/auth/send-otp",
        data: {},
        options: options,
      );
      return response.data;
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

  Future validateOwner({required String type, required String value}) async {
    try {
      Map requestData = {"type": type, "value": value};
      var options = await _getRequestOptions();
      Response response = await dioInstance.post("/auth/verification-challenge",
          data: requestData, options: options);
      return response;
    } catch (err, stacktrace) {
      if (kDebugMode) {
        print(err);
        print("Exception occured: $err stackTrace: $stacktrace");
      }
      throw Exception(err);
    }
  }
}
