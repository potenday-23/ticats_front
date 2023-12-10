import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ticats/app/service/auth_service.dart';
import 'package:ticats/domain/entities/ticats_member.dart';

class TokenInterceptor extends QueuedInterceptorsWrapper {
  final Dio _dio;
  final _authHeaderKey = 'Authorization';
  final _bearer = 'Bearer';

  TokenInterceptor(this._dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (kDebugMode) print('onRequest TokenInterceptor ${options.uri}');

    try {
      TicatsMember? user = AuthService.to.user;

      var localToken = user?.token?.accessToken;
      final expiredTime = user?.member?.updatedDate;
      final isExpired = expiredTime != null && user!.member!.updatedDate!.isAfter(DateTime.now().subtract(const Duration(days: 1)));
      if (isExpired) {
        // TODO: Implement token refresh logic
      } else {
        options.headers[_authHeaderKey] = '$_bearer $localToken';
      }
      handler.next(options);
    } on DioException catch (e) {
      handler.reject(e);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (kDebugMode) print('onError TokenInterceptor ${err.requestOptions.uri}');
    if (err.response?.statusCode == HttpStatus.unauthorized || err.response?.statusCode == HttpStatus.forbidden) {
      try {
        TicatsMember? user = AuthService.to.user;

        // Check latest token
        final request = err.requestOptions;
        final requestToken = request.headers[_authHeaderKey] ?? '';
        var localToken = user?.token?.accessToken;
        var latestToken = '$_bearer $localToken';
        if ((requestToken == latestToken) || (requestToken.isEmpty && localToken!.isEmpty)) {
          // latestToken = '$_bearer ${await _refreshToken()}';
        }

        // Update header
        request.headers.update(_authHeaderKey, (_) => latestToken, ifAbsent: () => latestToken);

        // Re-call request
        if (kDebugMode) print('re-call request ${request.uri}');
        final response = await _dio.request(
          request.path,
          data: request.data,
          queryParameters: request.queryParameters,
          cancelToken: request.cancelToken,
          options: Options(
            method: request.method,
            sendTimeout: request.sendTimeout,
            extra: request.extra,
            headers: request.headers,
            responseType: request.responseType,
            contentType: request.contentType,
            receiveDataWhenStatusError: request.receiveDataWhenStatusError,
            followRedirects: request.followRedirects,
            maxRedirects: request.maxRedirects,
            requestEncoder: request.requestEncoder,
            responseDecoder: request.responseDecoder,
            listFormat: request.listFormat,
          ),
          onReceiveProgress: request.onReceiveProgress,
        );

        return handler.resolve(response);
      } on DioException catch (e) {
        handler.reject(e);
      }
    }
    handler.next(err);
  }
}
