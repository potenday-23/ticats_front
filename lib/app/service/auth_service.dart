import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:ticats/app/config/routes/route_path.dart';
import 'package:ticats/data/datasources/local/auth_local_datasource.dart';
import 'package:ticats/domain/entities/ticats_member.dart';
import 'package:ticats/domain/entities/member_oauth.dart';
import 'package:ticats/domain/usecases/auth_use_cases.dart';
import 'package:ticats/presentation/common/widgets/ticats_dialog.dart';

enum SSOType { apple, kakao }

class AuthService extends GetxController {
  static AuthService get to => Get.find();

  Rx<TicatsMember> _member = const TicatsMember(member: null, token: null).obs;
  TicatsMember? get member => _member.value;

  MemberOAuth? _memberOAuth;
  MemberOAuth? get memberOAuth => _memberOAuth;

  MemberOAuth? tempMemberOAuth;

  bool get isLogin => member != null && !isTokenExpired;

  bool get isTokenExpired {
    if (member!.member == null) return true;

    return !member!.member!.updatedDate!.isAfter(DateTime.now().subtract(const Duration(days: 5)));
  }

  @override
  void onInit() async {
    super.onInit();

    await getCredential();

    if (member!.member == null) {
    } else if (isTokenExpired) {
      if (await refreshToken()) {
        Get.offAllNamed(RoutePath.main);
      } else {
        await logout();
        await showTextDialog(Get.context!, "로그인이 만료되었습니다. 다시 로그인해주세요.");
      }
    } else {
      Get.offAllNamed(RoutePath.main);
    }

    FlutterNativeSplash.remove();
  }

  Future<void> getCredential() async {
    var tempMember = await AuthLocalDataSource().getMember();

    if (tempMember != null) {
      _member = tempMember.obs;
    }

    _memberOAuth = await AuthLocalDataSource().getMemberOAuth();
  }

  Future<void> setMember(TicatsMember member) async {
    _member.value = member;

    AuthLocalDataSource().saveMember(member);
  }

  Future<void> setMemberOAuth(MemberOAuth memberOAuth) async {
    _memberOAuth = memberOAuth;

    AuthLocalDataSource().saveMemberOAuth(memberOAuth);
  }

  Future<void> logout() async {
    _member.value = const TicatsMember(member: null, token: null);
    _memberOAuth = null;
    tempMemberOAuth = null;

    await AuthLocalDataSource().deleteMember();
    await AuthLocalDataSource().deleteMemberOAuth();

    if (memberOAuth?.socialType == 'KAKAO') {
      try {
        await UserApi.instance.logout();
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  Future<bool> refreshToken() async {
    try {
      TicatsMember member = await Get.find<AuthUseCases>().loginUseCase.execute(memberOAuth!);

      await setMember(member);

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
