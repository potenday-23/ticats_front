import 'dart:io';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ticats/presentation/common/widgets/ticats_appbar.dart';

import 'package:ticats/presentation/make_ticket/controller/make_ticket_controller.dart';

class CropImagePage extends GetView<MakeTicketController> {
  CropImagePage({super.key, required this.image});

  final XFile image;

  final CropController _cropController = CropController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(title: "이미지 자르기"),
      body: Crop(
        controller: _cropController,
        image: File(image.path).readAsBytesSync(),
        aspectRatio: 324 / 564,
        cornerDotBuilder: (size, edgeAlignment) => const DotControl(color: Colors.transparent),
        fixArea: true,
        interactive: true,
        progressIndicator: const CircularProgressIndicator(),
        initialAreaBuilder: (rect) => Rect.fromLTRB(rect.left + 48, rect.top + 64, rect.right - 48, rect.bottom - 64),
        onCropped: (croppedImage) async {
          final String tempPath = (await getTemporaryDirectory()).path;

          final file = File('$tempPath/${DateTime.now().millisecondsSinceEpoch}.${image.path.split(".").last}');
          await file.writeAsBytes(croppedImage);

          controller.ticketImage.value = XFile(file.path);

          controller.isCropping.value = false;
          Get.back();
        },
      ),
      floatingActionButton: Obx(
        () => FloatingActionButton(
          onPressed: () {
            if (controller.isCropping.value) return;

            _cropController.crop();
            controller.isCropping.value = true;
          },
          child: controller.isCropping.value
              ? const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: CircularProgressIndicator(strokeWidth: 3),
                )
              : const Icon(Icons.crop),
        ),
      ),
    );
  }
}
