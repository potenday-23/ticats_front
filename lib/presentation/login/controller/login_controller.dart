import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginController extends GetxController {
  Future<void> loginWithApple() async {
    AuthorizationCredentialAppleID credential;

    try {
      credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      if (kDebugMode) {
        print(credential);
      }
    } catch (e) {
      if (kDebugMode) {
        print('애플 로그인 실패: $e');
      }
    }
  }

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
