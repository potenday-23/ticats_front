import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class LoginController extends GetxController {
  Future<void> loginWithKakao() async {
    User user;

    try {
      if (await isKakaoTalkInstalled()) {
        await UserApi.instance.loginWithKakaoTalk();
      } else {
        await UserApi.instance.loginWithKakaoAccount();
      }

      user = await UserApi.instance.me();

      if (kDebugMode) {
        print(user);
      }
    } catch (e) {
      if (kDebugMode) {
        print('카카오 로그인 실패: $e');
      }
    }
  }
}
