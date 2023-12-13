import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum HomeViewType { card, grid }

class HomeController extends GetxController with GetTickerProviderStateMixin {
  late final TabController tabController;

  final List<Tab> tabs = [const Tab(text: '전체'), const Tab(text: '내 티켓')];
  final RxInt tabIndex = 0.obs;
  final Rx<HomeViewType> myHomeViewType = HomeViewType.card.obs;
  final Rx<HomeViewType> totalHomeViewType = HomeViewType.card.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: tabs.length, vsync: this);
    tabController.addListener(() {
      tabIndex.value = tabController.index;
    });
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
