import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:http_parser/http_parser.dart';
import 'package:ticats/domain/entities/member_oauth.dart';
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
