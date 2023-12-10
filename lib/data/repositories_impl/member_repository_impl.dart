import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:ticats/domain/entities/user_oauth.dart';
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
}
