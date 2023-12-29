import 'package:get/get.dart';
import 'package:ticats/presentation/home/controller/search_ticket_controller.dart';

import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
    Get.lazyPut<SearchTicketController>(() => SearchTicketController(), fenix: true);
  }
}
