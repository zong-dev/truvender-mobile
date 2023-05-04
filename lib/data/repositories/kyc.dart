import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class KycRepository {
  static String? baseUrl = dotenv.get('BASE_URL');
  static String endpoint = '$baseUrl/auth';

  final Dio dioInstance;

  KycRepository({ required this.dioInstance });

  FlutterSecureStorage storage = const FlutterSecureStorage();

  tierOneVerification(String value) async {
     var options = await _getRequestOptions();
    var response = await dioInstance.post("$endpoint/kyc/tier1/submit",
        data: {"value": value},
        options: options);
    return response;
  }

  tierTwoVerification({
    required String name,
    required String type,
    required String dateOfBirth,
    required String documentCode,
    required String documentUrl
  }) async {
    var options = await _getRequestOptions();
    var response = await dioInstance.post("$endpoint/kyc/tier2/submit",
        data: {
          "name": name,
          "dateOfBirth": dateOfBirth,
          "type": type,
          "document": documentUrl
        },
        options: options);
    return response;
  }


  Future<Options> _getRequestOptions() async {
    final authToken = await storage.read(key: 'tru-token');
    return Options(headers: {"authorization": "Bearer $authToken"});
  }
}

