import 'dart:io';
import 'package:dio/dio.dart';
import 'package:truvender/interceptors/dio_connectivity_request_retrier.dart';

class RetryOnConnectionChangeIterceptor extends Interceptor {
  final DioConnectivityRequestRetrier requestRetrier;

  RetryOnConnectionChangeIterceptor({required this.requestRetrier});

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      try {
        return requestRetrier.scheduleRequestRetry(err.requestOptions);
      } catch (e) {
        return e;
      }
    }
    return err;
  }

  // @override
  // void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
  //   print(options.method);
  //   print(options.path);
  //   handler.next(options);
  // }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  bool _shouldRetry(DioError err) {
    return err.type == DioErrorType &&
        err.error != null &&
        err.error is SocketException;
  }
}
