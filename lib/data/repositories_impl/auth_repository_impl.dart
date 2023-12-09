import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:http_parser/http_parser.dart';
import 'package:ticats/domain/entities/ticats_member.dart';
import 'package:ticats/domain/repositories/auth_repository.dart';

import '../datasources/remote/auth_api.dart';
import '../models/ticats_member_model.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthAPI _api = Get.find();

  @override
  Future<TicatsMember> login(UserOAuth userOAuth) async {
    TicatsMemberModel user = await _api.login({
      'request': MultipartFile.fromString(
        jsonEncode({'socialId': userOAuth.socialId, 'socialType': userOAuth.socialType}),
        contentType: MediaType('application', 'json'),
      ),
    });

    return TicatsMember(
      member: Member.fromJson(user.member!.toJson()),
      token: Token.fromJson(user.token!.toJson()),
      userOAuth: userOAuth,
    );
  }
}
