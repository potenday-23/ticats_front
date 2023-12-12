import 'package:get/get.dart';

import 'home_controller.dart';
import 'main_controller.dart';
import 'ticket_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainController());
    Get.put(HomeController());
    Get.put(TicketController());
  }
}
