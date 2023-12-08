import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' hide User;
import 'package:ticats/data/datasources/local/auth_local_datasource.dart';
import 'package:ticats/domain/entities/user.dart';

enum SSOType { apple, kakao }

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  User? _user;
  User? get user => _user;

  bool get isTokenExpired {
    if (user == null) return false;

    return !user!.member!.updatedDate!.isAfter(DateTime.now().subtract(const Duration(days: 1)));
  }

  @override
  void onInit() async {
    super.onInit();

    await getUser();

    if (_user == null) {
      return;
    } else if (isTokenExpired) {
      await Fluttertoast.showToast(
        msg: '로그인이 만료되었습니다. 다시 로그인해주세요.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      Get.offAllNamed('/home');
    }
  }

  Future<void> getUser() async {
    _user = await AuthLocalDataSource().getUser();
  }

  Future<void> setUser(User user) async {
    _user = user;

    AuthLocalDataSource().saveUser(user);
  }

  Future<void> logout() async {
    if (user?.userOAuth?.socialType == 'KAKAO') {
      await UserApi.instance.logout();
    }

    await AuthLocalDataSource().deleteUser();
  }
}
