import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/main_controller.dart';
import '../widgets/main_bottom_nav_bar.dart';

class MainPage extends GetView<MainController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.selectedIndex,
            children: controller.pages,
          )),
      bottomNavigationBar: const MainBottomNavBar(),
    );
  }
}
