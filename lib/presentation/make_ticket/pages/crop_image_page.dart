import 'dart:io';
import 'dart:typed_data';

import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ticats/app/config/app_typeface.dart';
import 'package:ticats/presentation/common/widgets/ticats_appbar.dart';
import 'package:ticats/presentation/make_ticket/controller/make_ticket_controller.dart';

class CropImagePage extends GetView<MakeTicketController> {
  CropImagePage({super.key, required this.image});

  final CustomImageCropController _cropController = CustomImageCropController();

  final Uint8List image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const BackAppBar(title: "이미지 자르기"),
      body: SafeArea(
        child: CustomImageCrop(
          cropController: _cropController,
          image: MemoryImage(image),
          shape: CustomCropShape.Ratio,
          ratio: Ratio(width: 57, height: 94),
          forceInsideCropArea: true,
          imageFit: CustomImageFit.fillCropHeight,
          canRotate: false,
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 74.w,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    _cropController.addTransition(CropImageData(angle: -3.14 / 2));
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.w),
                    child: SvgPicture.asset('assets/icons/rotate.svg', width: 17.5.w, height: 21.w),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    if (controller.isCropping.value) return;

                    controller.isCropping.value = true;

                    final MemoryImage? croppedImage = await _cropController.onCropImage();
                    _cropController.dispose();

                    if (croppedImage != null) {
                      final directory = (await getTemporaryDirectory()).path;
                      final newImage = await File('$directory/${DateTime.now().millisecondsSinceEpoch}').create();
                      await newImage.writeAsBytes(croppedImage.bytes);

                      controller.ticketImage.value = XFile(newImage.path);

                      Get.back();
                    }

                    controller.isCropping.value = false;
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.w),
                    child: Obx(() {
                      if (controller.isCropping.value) {
                        return SizedBox(width: 21.w, height: 21.w, child: const CircularProgressIndicator());
                      }

                      return Row(
                        children: [
                          SvgPicture.asset('assets/icons/rotate.svg', width: 17.5.w, height: 21.w),
                          SizedBox(width: 10.w),
                          Text("자르기 완료", style: AppTypeFace.xSmall16SemiBold),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
