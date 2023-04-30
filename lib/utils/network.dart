import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

uploadFile({required Dio dioInstance, required File file}) async {
  try {
    String? baseUrl = dotenv.get('BASE_URL');
    String endpoint = '$baseUrl/media/upload';
    FormData formData = FormData.fromMap({
      "media": await MultipartFile.fromFile(file.path),
    });
    Response response = await dioInstance.post(endpoint, data: formData);
    return response.data['url'];
  } catch (e) {
    return e;
  }
}
