// ignore_for_file: unnecessary_cast

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ticats/app/service/auth_service.dart';
import 'package:ticats/domain/entities/ticket.dart';
import 'package:ticats/domain/usecases/ticket_use_cases.dart';

class SearchTicketController extends GetxController {
  RxList<Ticket> searchTicketList = <Ticket>[].obs;

  RxBool isLoading = false.obs;

  final TextEditingController searchTextController = TextEditingController();

  final RxBool isMyTicket = false.obs;
  final RxString dateType = "".obs;
  final RxList<String> categoryList = <String>[].obs;

  Rx<DateTime?> rangeStart = (null as DateTime?).obs;
  Rx<DateTime?> rangeEnd = (null as DateTime?).obs;

  Future<void> searchTicket() async {
    isLoading.value = true;

    if (AuthService.to.isLogin) {
      searchTicketList.assignAll(
        await Get.find<TicketUseCases>().searchTicketUseCase.execute(
              categorys: categoryList,
              period: dateType.value,
              start: dateType.value == "day" && rangeStart.value != null ? DateFormat('yyyy-MM-dd').format(rangeStart.value!) : null,
              end: dateType.value == "day" && rangeStart.value != null ? DateFormat('yyyy-MM-dd').format(rangeEnd.value!) : null,
              search: searchTextController.text,
            ),
      );
    } else {
      searchTicketList.assignAll(
        await Get.find<TicketUseCases>().getTotalTicketUseCase.execute(
              categorys: categoryList,
              period: dateType.value,
              start: dateType.value == "day" && rangeStart.value != null ? DateFormat('yyyy-MM-dd').format(rangeStart.value!) : null,
              end: dateType.value == "day" && rangeStart.value != null ? DateFormat('yyyy-MM-dd').format(rangeEnd.value!) : null,
              search: searchTextController.text,
            ),
      );
    }

    isLoading.value = false;
  }
}
