import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService extends GetxService {
  static PermissionService get to => Get.find();

  Future<bool> checkPhotoPermission() async {
    final status = await Permission.photos.status;

    return status == PermissionStatus.granted;
  }

  Future<bool> requestPhotoPermission() async {
    final status = await Permission.photos.request();

    return status == PermissionStatus.granted;
  }
}
