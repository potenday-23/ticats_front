import 'package:get/get.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    injectNetworkProvider();
    injectService();
  }

  void injectNetworkProvider() {}

  void injectService() {}
}
