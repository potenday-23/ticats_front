import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:http_parser/http_parser.dart';
import 'package:ticats/domain/entities/register_entity.dart';
import 'package:ticats/domain/entities/ticats_member.dart';
import 'package:ticats/domain/entities/member_oauth.dart';
import 'package:ticats/domain/repositories/auth_repository.dart';

import '../datasources/remote/auth_api.dart';
import '../models/ticats_member_model.dart';
import 'mapper/member_mapper.dart';

final MemberMapper _memberMapper = MemberMapper();

class AuthRepositoryImpl extends AuthRepository {
  final AuthAPI _api = Get.find();

  @override
  Future<TicatsMember> login(MemberOAuth memberOAuth) async {
    TicatsMemberModel memberModel = await _api.login({
      'request': MultipartFile.fromString(
        jsonEncode({'socialId': memberOAuth.socialId, 'socialType': memberOAuth.socialType}),
        contentType: MediaType('application', 'json'),
      ),
    });

    return _memberMapper.convert<TicatsMemberModel, TicatsMember>(memberModel);
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

    TicatsMemberModel memberModel = await _api.register(data);

    return _memberMapper.convert<TicatsMemberModel, TicatsMember>(memberModel);
  }
}
