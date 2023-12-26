import 'package:get/get.dart';

import 'make_ticket_controller.dart';

class MakeTicketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MakeTicketController>(() => MakeTicketController());
  }
}
