import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:ticats/app/config/routes/route_path.dart';
import 'package:ticats/app/service/auth_service.dart';
import 'package:ticats/domain/entities/ticats_member.dart';
import 'package:ticats/domain/entities/member_oauth.dart';
import 'package:ticats/domain/usecases/auth_use_cases.dart';
import 'package:ticats/domain/usecases/member_use_cases.dart';

enum SSOType { apple, kakao }

class LoginController extends GetxController {
  final AuthUseCases authUseCases = Get.find<AuthUseCases>();
  final MemberUseCases memberUseCases = Get.find<MemberUseCases>();

  CheckMemberUseCase get checkMemberUseCase => memberUseCases.checkMemberUseCase;
  LoginUseCase get loginUseCase => authUseCases.loginUseCase;

  Future<void> login(SSOType type) async {
    MemberOAuth? memberOAuth;

    if (type == SSOType.apple) {
      memberOAuth = await loginWithApple();
    } else if (type == SSOType.kakao) {
      memberOAuth = await loginWithKakao();
    }

    // SSO 로그인 성공
    if (memberOAuth != null) {
      // User 정보가 있는지 확인
      // 있으면 로그인 / 없으면 회원가입
      bool isMemberExist = await checkMemberUseCase.execute(memberOAuth);

      if (isMemberExist) {
        try {
          TicatsMember member = await loginUseCase.execute(memberOAuth);

          await AuthService.to.setMember(member);
          await AuthService.to.setMemberOAuth(memberOAuth);

          Get.toNamed(RoutePath.home);
        } catch (e) {
          if (kDebugMode) print(e);
        }
      } else {
        AuthService.to.tempMemberOAuth = memberOAuth;

        Get.toNamed(RoutePath.termAgree);
      }
    }
  }

  Future<MemberOAuth?> loginWithApple() async {
    AuthorizationCredentialAppleID credential;

    try {
      credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      if (kDebugMode) print(credential);

      return MemberOAuth(socialId: credential.userIdentifier!, socialType: 'APPLE');
    } catch (e) {
      if (kDebugMode) print('애플 로그인 실패: $e');
    }
    return null;
  }

  Future<MemberOAuth?> loginWithKakao() async {
    User user;

    try {
      if (await isKakaoTalkInstalled()) {
        await UserApi.instance.loginWithKakaoTalk();
      } else {
        await UserApi.instance.loginWithKakaoAccount();
      }

      user = await UserApi.instance.me();

      if (kDebugMode) print(user);

      return MemberOAuth(socialId: user.id.toString(), socialType: 'KAKAO');
    } catch (e) {
      if (kDebugMode) print('카카오 로그인 실패: $e');
    }
    return null;
  }
}
