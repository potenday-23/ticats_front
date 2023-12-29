import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';
import 'package:ticats/app/config/routes/route_path.dart';
import 'package:ticats/app/service/auth_service.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (!AuthService.to.isLogin) {
      return const RouteSettings(name: RoutePath.alterLogin);
    }
    return null;
  }
}
