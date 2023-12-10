import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' hide User;
import 'package:ticats/data/datasources/local/auth_local_datasource.dart';
import 'package:ticats/domain/entities/ticats_member.dart';
import 'package:ticats/domain/entities/user_oauth.dart';

enum SSOType { apple, kakao }

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  TicatsMember? _user;
  TicatsMember? get user => _user;

  UserOAuth? _userOAuth;
  UserOAuth? get userOAuth => _userOAuth;

  UserOAuth? tempUserOAuth;

  bool get isTokenExpired {
    if (user == null) return false;

    return !user!.member!.updatedDate!.isAfter(DateTime.now().subtract(const Duration(days: 1)));
  }

  @override
  void onInit() async {
    super.onInit();

    await getCredential();

    if (_user == null) {
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
    _user = await AuthLocalDataSource().getUser();
    _userOAuth = await AuthLocalDataSource().getUserOAuth();
  }

  Future<void> setUser(TicatsMember user) async {
    _user = user;

    AuthLocalDataSource().saveUser(user);
  }

  Future<void> setUserOAuth(UserOAuth userOAuth) async {
    _userOAuth = userOAuth;

    AuthLocalDataSource().saveUserOAuth(userOAuth);
  }

  Future<void> logout() async {
    if (userOAuth?.socialType == 'KAKAO') {
      await UserApi.instance.logout();
    }

    await AuthLocalDataSource().deleteUser();
  }
}
