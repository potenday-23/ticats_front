import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as kakao;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:ticats/app/config/routes/route_path.dart';
import 'package:ticats/app/service/auth_service.dart';
import 'package:ticats/domain/entities/user.dart';
import 'package:ticats/domain/usecases/auth_use_cases.dart';

enum SSOType { apple, kakao }

class LoginController extends GetxController {
  final AuthUseCases authUseCases = Get.find<AuthUseCases>();

  CheckUserUseCase get checkUserUseCase => authUseCases.checkUserUseCase;
  LoginUseCase get loginUseCase => authUseCases.loginUseCase;

  Future<void> login(SSOType type) async {
    UserOAuth? userOAuth;

    if (type == SSOType.apple) {
      userOAuth = await loginWithApple();
    } else if (type == SSOType.kakao) {
      userOAuth = await loginWithKakao();
    }

    // SSO 로그인 성공
    if (userOAuth != null) {
      bool checkUserResult = await checkUserUseCase.execute(userOAuth);

      // User 정보가 있는지 확인
      // 있으면 로그인 / 없으면 회원가입
      if (checkUserResult) {
        User user = await loginUseCase.execute(userOAuth);
        await AuthService.to.setUser(user);

        Get.toNamed(RoutePath.termAgree);
      } else {
        Get.toNamed(RoutePath.home);
      }
    }
  }

  Future<UserOAuth?> loginWithApple() async {
    AuthorizationCredentialAppleID credential;

    try {
      credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      if (kDebugMode) print(credential);

      return UserOAuth(socialId: credential.userIdentifier!, socialType: 'APPLE');
    } catch (e) {
      if (kDebugMode) print('애플 로그인 실패: $e');
    }
    return null;
  }

  Future<UserOAuth?> loginWithKakao() async {
    kakao.User user;

    try {
      if (await kakao.isKakaoTalkInstalled()) {
        await kakao.UserApi.instance.loginWithKakaoTalk();
      } else {
        await kakao.UserApi.instance.loginWithKakaoAccount();
      }

      user = await kakao.UserApi.instance.me();

      if (kDebugMode) print(user);

      return UserOAuth(socialId: user.id.toString(), socialType: 'KAKAO');
    } catch (e) {
      if (kDebugMode) print('카카오 로그인 실패: $e');
    }
    return null;
  }
}
