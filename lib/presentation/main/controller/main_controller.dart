import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticats/presentation/home/controller/home_controller.dart';
import 'package:ticats/presentation/home/pages/home_view.dart';
import 'package:ticats/presentation/make_ticket/pages/my_ticket_view.dart';
import 'package:ticats/presentation/my_page/pages/my_page_view.dart';

class MainController extends GetxController {
  List<Widget> pages = [
    const HomeView(),
    const MyTicketView(),
    const MyPageView(),
  ];

  final _selectedIndex = 0.obs;
  int get selectedIndex => _selectedIndex.value;

  void changePage(int index) {
    if (index == 0 && _selectedIndex.value == 0) {
      if (Get.find<HomeController>().tabIndex.value == 0) {
        Get.find<HomeController>()
            .totalPageController
            .animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      } else {
        Get.find<HomeController>().myPageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    }

    _selectedIndex.value = index;
  }
}
