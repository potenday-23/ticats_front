import 'dart:io';
import 'dart:typed_data';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ticats/app/config/app_typeface.dart';
import 'package:ticats/presentation/common/widgets/ticats_appbar.dart';
import 'package:ticats/presentation/common/widgets/ticats_ticket.dart';
import 'package:ticats/presentation/home/controller/home_controller.dart';
import 'package:ticats/presentation/main/controller/main_controller.dart';
import 'package:ticats/presentation/make_ticket/controller/make_ticket_controller.dart';

class MakeTicketResultPage extends GetView<MakeTicketController> {
  MakeTicketResultPage({super.key});

  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CloseAppBar(
        title: "티켓 만들기",
        onTap: () {
          Get.find<MainController>().changePage(0);
          Get.back();
        },
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 60.h),
        child: Align(
          alignment: Alignment.topCenter,
          child: Screenshot(
            controller: _screenshotController,
            child: SizedBox(
              height: 564.h,
              child: RepaintBoundary(
                child: FlipCard(
                  front: TicketFront(controller.ticket.value, hasLike: false),
                  back: TicketBack(controller.ticket.value),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: const VisualDensity(horizontal: -4, vertical: 0),
        ),
        onPressed: () async {
          await _screenshotController.capture(delay: const Duration(milliseconds: 10)).then((Uint8List? image) async {
            if (image != null) {
              final directory = await getApplicationDocumentsDirectory();
              final imagePath = await File('${directory.path}/image.png').create();
              await imagePath.writeAsBytes(image);

              await Share.shareXFiles([XFile(imagePath.path)]);
            }
          });
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset('assets/icons/download.svg', width: 24.w, height: 24.w),
            SizedBox(width: 4.w),
            Text('다운로드', style: AppTypeFace.xSmall12Bold),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
