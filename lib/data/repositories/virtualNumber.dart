import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class VirtualNumberRepository {
  static String? baseUrl = dotenv.get('BASE_URL');
  static String endpoint = '$baseUrl/virtual-number';

  final Dio dioInstance;

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  VirtualNumberRepository({required this.dioInstance});

  Future getTargets() async {
    try {
      var options = await _getRequestOptions();
      Response response =
          await dioInstance.get("$endpoint/targets", options: options);
      return response;
    } catch (err, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $err stackTrace: $stacktrace");
      }
      throw Exception(err);
    }
  }

  Future buyTarget({
    required String targetId,
  }) async {
    try {
      var options = await _getRequestOptions();
      Response response = await dioInstance.post(
          "$endpoint/buy-target",
          data: {"targetId": targetId},
          options: options);
      return response;
    } catch (err, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $err stackTrace: $stacktrace");
      }
      throw Exception(err);
    }
  }

  Future getVerificationDetails({ required String id}) async {
    try {
      const String endPoint = "https://www.textverified.com/api";
      String? tvToken = dotenv.get('TEXTV_TOKEN');
      Response response = await dioInstance.get("$endPoint/api/Verifications/$id", options: Options(headers: {"authorization": "Bearer $tvToken"}));
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
