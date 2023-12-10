import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:ticats/data/datasources/local/auth_local_datasource.dart';
import 'package:ticats/domain/entities/ticats_member.dart';
import 'package:ticats/domain/entities/member_oauth.dart';

enum SSOType { apple, kakao }

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  TicatsMember? _member;
  TicatsMember? get member => _member;

  MemberOAuth? _memberOAuth;
  MemberOAuth? get memberOAuth => _memberOAuth;

  MemberOAuth? tempMemberOAuth;

  bool get isTokenExpired {
    if (member == null) return true;

    return !member!.member!.updatedDate!.isAfter(DateTime.now().subtract(const Duration(days: 1)));
  }

  @override
  void onInit() async {
    super.onInit();

    await getCredential();

    if (_member == null) {
      return;
    } else if (isTokenExpired) {
      await Fluttertoast.showToast(
        msg: '로그인이 만료되었습니다. 다시 로그인해주세요.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      // Get.offAllNamed('/home');
    }
  }

  Future<void> getCredential() async {
    _member = await AuthLocalDataSource().getMember();
    _memberOAuth = await AuthLocalDataSource().getMemberOAuth();
  }

  Future<void> setMember(TicatsMember member) async {
    _member = member;

    AuthLocalDataSource().saveMember(member);
  }

  Future<void> setMemberOAuth(MemberOAuth memberOAuth) async {
    _memberOAuth = memberOAuth;

    AuthLocalDataSource().saveMemberOAuth(memberOAuth);
  }

  Future<void> logout() async {
    if (memberOAuth?.socialType == 'KAKAO') {
      await UserApi.instance.logout();
    }

    await AuthLocalDataSource().deleteMember();
  }
}
