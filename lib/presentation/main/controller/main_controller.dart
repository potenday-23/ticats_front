import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticats/presentation/home/pages/home_view.dart';
import 'package:ticats/presentation/make_ticket/pages/make_ticket_view.dart';
import 'package:ticats/presentation/my_page/pages/my_page_view.dart';

class MainController extends GetxController {
  List<Widget> pages = [
    const HomeView(),
    const MakeTicketView(),
    const MyPageView(),
  ];

  final _selectedIndex = 0.obs;
  int get selectedIndex => _selectedIndex.value;

  void changePage(int index) {
    _selectedIndex.value = index;
  }
}
