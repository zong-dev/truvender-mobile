import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:truvender/utils/utils.dart';

class KycRepository {
  static String? baseUrl = dotenv.get('BASE_URL');
  static String endpoint = '$baseUrl/auth';

  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final Dio _dio = Dio();


  tierOneVerification(String value) async {
    var token = await storage.read(key: 'tru-token');
    var response = await _dio.post("$endpoint/kyc/tier1/submit",
        data: {"value": value},
        options: Options(headers: {"Authorization": "$token"}));
    return response;
  }

  tierTwoVerification({
    required String name,
    required String type,
    required String dateOfBirth,
    required String documentCode,
    required File document,
  }) async {
    var token = await storage.read(key: 'tru-token');
    var documentUrl =
        await uploadFile(dioInstance: _dio, file: document);
    if (documentUrl) {
      var response = await _dio.post("$endpoint/kyc/tier2/submit",
          data: {
            "name": name,
            "dateOfBirth": dateOfBirth,
            "type": type,
            "document": documentUrl
          },
          options: Options(headers: {"Authorization": "$token"}));
      return response;
    }
  }
}
