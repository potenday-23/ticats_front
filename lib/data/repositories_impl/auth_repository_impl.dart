import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:http_parser/http_parser.dart';
import 'package:ticats/domain/entities/user.dart';
import 'package:ticats/domain/repositories/auth_repository.dart';

import '../datasources/remote/auth_api.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthAPI _api = Get.find();

  @override
  Future<bool> checkUser(UserOAuth userOAuth) async {
    try {
      await _api.checkUser(userOAuth.socialId, userOAuth.socialType);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        return false;
      } else {
        return Future.error(e);
      }
    }

    return true;
  }

  @override
  Future<User> login(UserOAuth userOAuth) async {
    UserModel user = await _api.login({
      'request': MultipartFile.fromString(
        jsonEncode({'socialId': userOAuth.socialId, 'socialType': userOAuth.socialType}),
        contentType: MediaType('application', 'json'),
      ),
    });

    return User(
      member: Member.fromJson(user.member!.toJson()),
      token: Token.fromJson(user.token!.toJson()),
      userOAuth: userOAuth,
    );
  }
}
