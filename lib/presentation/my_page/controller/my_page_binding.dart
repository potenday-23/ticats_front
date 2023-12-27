import 'package:get/get.dart';
import 'package:ticats/presentation/my_page/controller/statistic_controller.dart';

class MyPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StatisticController>(() => StatisticController(), fenix: true);
  }
}
