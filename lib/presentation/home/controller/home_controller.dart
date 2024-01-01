import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticats/app/service/auth_service.dart';
import 'package:ticats/domain/entities/ticats_member.dart';
import 'package:ticats/domain/repositories/auth_repository.dart';
import 'package:ticats/presentation/common/widgets/ticats_tutorial.dart';
import 'package:ticats/presentation/main/controller/ticket_controller.dart';

enum HomeViewType { card, grid }

class HomeController extends GetxController with GetTickerProviderStateMixin {
  late final TabController tabController;

  final List<Tab> tabs = [const Tab(text: '전체'), const Tab(text: '내 티켓')];
  final RxInt tabIndex = 0.obs;
  final Rx<HomeViewType> myHomeViewType = HomeViewType.card.obs;
  final Rx<HomeViewType> totalHomeViewType = HomeViewType.card.obs;

  final RxList<String> categoryList = <String>[].obs;

  @override
  void onInit() async {
    super.onInit();
    tabController = TabController(length: tabs.length, vsync: this);
    tabController.addListener(() {
      tabIndex.value = tabController.index;
    });
  }

  @override
  void onReady() async {
    super.onReady();

    await showTutorial();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<void> showTutorial() async {
    SharedPreferences.getInstance().then((prefs) async {
      if (prefs.getBool("isFinishTutorial") != true) {
        await showExampleDialog(Get.context!);
        prefs.setBool("isFinishTutorial", true);
      }
    });
  }

  Future<void> saveCategory() async {
    try {
      TicatsMember member = await Get.find<AuthRepository>().saveCategorys(categoryList);

      AuthService.to.setMember(member);
      await Get.find<TicketController>().getTickets();
      Get.back();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
