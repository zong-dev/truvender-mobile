import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupportRepository {
   static String? baseUrl = dotenv.get('BASE_URL');
  static String endpoint = '$baseUrl/bills';
  final Dio dioInstance;

  SupportRepository({ required this.dioInstance});

  
  
}