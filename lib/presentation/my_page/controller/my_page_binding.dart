import 'package:get/get.dart';
import 'package:ticats/presentation/my_page/controller/edit_profile_controller.dart';
import 'package:ticats/presentation/my_page/controller/resign_controller.dart';
import 'package:ticats/presentation/my_page/controller/statistic_controller.dart';

class MyPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditProfileController>(() => EditProfileController(), fenix: true);
    Get.lazyPut<ResignController>(() => ResignController(), fenix: true);
    Get.lazyPut<StatisticController>(() => StatisticController(), fenix: true);
  }
}
