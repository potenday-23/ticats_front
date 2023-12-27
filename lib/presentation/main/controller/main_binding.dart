import 'package:get/get.dart';
import 'package:ticats/presentation/home/controller/home_binding.dart';
import 'package:ticats/presentation/make_ticket/controller/make_ticket_binding.dart';
import 'package:ticats/presentation/my_page/controller/my_page_binding.dart';

import 'main_controller.dart';
import 'ticket_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainController());
    Get.put(TicketController());

    // Inject Home
    HomeBinding().dependencies();

    // Inject MakeTicket
    MakeTicketBinding().dependencies();

    // Inject MyPage
    MyPageBinding().dependencies();
  }
}
