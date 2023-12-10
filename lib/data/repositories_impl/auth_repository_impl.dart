import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:http_parser/http_parser.dart';
import 'package:ticats/domain/entities/register_entity.dart';
import 'package:ticats/domain/entities/ticats_member.dart';
import 'package:ticats/domain/entities/user_oauth.dart';
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
    );
  }

  @override
  Future<TicatsMember> register(RegisterEntity registerEntity) async {
    var data = {
      'request': MultipartFile.fromString(
        jsonEncode({
          'socialId': registerEntity.socialId,
          'socialType': registerEntity.socialType,
          'nickname': registerEntity.nickname,
          'pushAgree': registerEntity.pushAgree,
          'marketingAgree': registerEntity.marketingAgree,
        }),
        contentType: MediaType('application', 'json'),
      ),
      'categorys': MultipartFile.fromString(
        jsonEncode(registerEntity.categorys),
        contentType: MediaType('application', 'json'),
      ),
    };

    if (registerEntity.profileImage!.path.isNotEmpty) {
      data.addEntries([
        MapEntry(
          'profileImage',
          await MultipartFile.fromFile(registerEntity.profileImage!.path, filename: registerEntity.profileImage!.name),
        ),
      ]);
    }

    TicatsMemberModel user = await _api.register(data);

    return TicatsMember(
      member: Member.fromJson(user.member!.toJson()),
      token: Token.fromJson(user.token!.toJson()),
    );
  }
}
