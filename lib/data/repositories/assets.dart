import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AssetRepository {

  static String? baseUrl = dotenv.get('BASE_URL');
  static String endpoint = '$baseUrl';
  final Dio dioInstance;

  AssetRepository({ required this.dioInstance});

  Future getCryptoAssets(String? id) async {
    try {
      Response response =
          await dioInstance.get("$endpoint/crypto/assets", queryParameters: {
        "id": id,
      });
      return response;
    } catch (error, stacktrace) {
      if(kDebugMode){
        print("Exception occured: $error stackTrace: $stacktrace");
      }
      throw Exception(error);
    }
    
  }

  Future getTradableFunds(String? id) async {
    try {
      String aId = id ?? '';
      Response response = await dioInstance.get("$endpoint/funds/$aId");
      return response;
    } catch (error, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $error stackTrace: $stacktrace");
      }
      throw Exception(error);
    }
  }

  Future getGiftcards({int page = 1, required String query}) async {
    try {
      Response response = await dioInstance.get("$endpoint/giftcards",
          queryParameters: {"page": page, "query": query});
      return response;
    } catch (error, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $error stackTrace: $stacktrace");
      }
      throw Exception(error);
    }
  }

  Future getSpendingCards({int page = 0, String query = ''}) async {
    try {
      Response response = await dioInstance.get("$endpoint/giftcards/spending",
          queryParameters: {"page": page, "query": query});

      return response;
    } catch (error, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $error stackTrace: $stacktrace");
      }
      throw Exception(error);
    }
  }

  Future getCardData({required String id, String? type}) async {
    try {
      Response response = await dioInstance.get(
        "$endpoint/giftcards/data/$id",
        queryParameters: {"type": type},
      );
      return response;
    } catch (error, stacktrace) {
      if (kDebugMode) {
        print("Exception occured: $error stackTrace: $stacktrace");
      }
      throw Exception(error);
    }
  }

}