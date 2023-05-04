import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

uploadFile({required Dio dioInstance, required File file}) async {
  try {
    String? baseUrl = dotenv.get('BASE_URL');
    String endpoint = '$baseUrl/media/upload';
    FlutterSecureStorage storage = const FlutterSecureStorage();
    final authToken = await storage.read(key: 'tru-token');
    FormData formData = FormData.fromMap({
      "media": await MultipartFile.fromFile(file.path),
    });
    Response response = await dioInstance.post(endpoint,
        data: formData,
        options: Options(
          responseType: ResponseType.json,
          headers: {
            'accept': 'application/json',
            'Content-Type': 'multipart/form-data',
            "authorization": "Bearer $authToken"
          },
        ));
    return response.data;
  } catch (e) {
    return e;
  }
}
