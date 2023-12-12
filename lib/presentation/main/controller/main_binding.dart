import 'package:get/get.dart';
import 'package:ticats/presentation/home/controller/home_binding.dart';

import 'main_controller.dart';
import 'ticket_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainController());
    Get.put(TicketController());

    // Inject Home
    HomeBinding().dependencies();
  }
}
