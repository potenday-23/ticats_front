import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ticats/app/config/app_const.dart';
import 'package:ticats/app/network/interceptor/token_interceptor.dart';

enum DioBuilderType { refresh, withToken, withoutToken }

class DioBuilder extends DioMixin implements Dio {
  final Duration connectionTimeOutMls = const Duration(milliseconds: 10000);
  final Duration readTimeOutMls = const Duration(milliseconds: 10000);
  final Duration writeTimeOutMls = const Duration(milliseconds: 10000);

  DioBuilder({
    required BaseOptions options,
    bool withToken = true,
    Dio? refreshDio,
  }) {
    options = BaseOptions(
      responseType: ResponseType.json,
      baseUrl: AppConst.baseUrl,
      contentType: Headers.jsonContentType,
      connectTimeout: connectionTimeOutMls,
      receiveTimeout: readTimeOutMls,
      sendTimeout: writeTimeOutMls,
    );

    this.options = options;

    // Add interceptor for JWT
    if (withToken && refreshDio != null) {
      interceptors.add(TokenInterceptor(refreshDio));
    }

    // Add interceptor for logging
    if (kDebugMode) {
      interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }

    httpClientAdapter = HttpClientAdapter();
  }
}
