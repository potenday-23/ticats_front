import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ticats/app/service/auth_service.dart';
import 'package:ticats/domain/entities/member_oauth.dart';
import 'package:ticats/domain/entities/ticats_member.dart';
import 'package:ticats/domain/repositories/member_repository.dart';

import '../datasources/remote/member_api.dart';

class MemberRepositoryImpl extends MemberRepository {
  final MemberAPI _api = Get.find();

  @override
  Future<bool> checkNickname(String nickname) async {
    try {
      await _api.checkNickname(nickname);
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
  Future<bool> checkMember(MemberOAuth memberOAuth) async {
    try {
      await _api.checkMember(memberOAuth.socialId, memberOAuth.socialType);
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
  Future<Member> patchMember(String nickname, XFile? image) async {
    Map<String, MultipartFile> data = {};

    if (nickname != AuthService.to.member!.member!.nickname && nickname.isNotEmpty) {
      data.addEntries([
        MapEntry(
          'request',
          MultipartFile.fromString(
            jsonEncode({'nickname': nickname}),
            contentType: MediaType('application', 'json'),
          ),
        ),
      ]);
    } else {
      data.addEntries([
        MapEntry(
          'request',
          MultipartFile.fromString(
            jsonEncode({}),
            contentType: MediaType('application', 'json'),
          ),
        ),
      ]);
    }

    if (image!.path.isNotEmpty) {
      data.addEntries([
        MapEntry('profileImage', await MultipartFile.fromFile(image.path, filename: image.name)),
      ]);
    }

    return await _api.patchMember(data);
  }

  @override
  Future<void> resignMember(List<int> resignReason) async {
    var data = {
      'quits': MultipartFile.fromString(
        jsonEncode(resignReason),
        contentType: MediaType('application', 'json'),
      ),
    };

    await _api.resignMember(data);
  }
}
