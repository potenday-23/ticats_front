import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

showExampleDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.65),
    builder: (BuildContext context) {
      return GestureDetector(
        onTap: () async {
          Get.back();
          showExample2Dialog(context);
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Center(
              child: Image.asset('assets/tutorial/tutorial_1.png', width: 139.w, height: 100.w, fit: BoxFit.cover),
            ),
          ),
        ),
      );
    },
  );
}

showExample2Dialog(BuildContext context) async {
  return await showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.65),
    builder: (BuildContext context) {
      return GestureDetector(
        onTap: () async {
          Get.back();
          showExample3Dialog(context);
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 46.w, right: 77.w),
                    child: Align(
                        alignment: Alignment.topRight,
                        child: Image.asset('assets/tutorial/tutorial_2.png', width: 139.w, height: 48.w, fit: BoxFit.cover))),
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 66.w + 60.w, right: 10.w),
                      child: Align(
                          alignment: Alignment.bottomRight,
                          child: Image.asset('assets/tutorial/tutorial_3.png', width: 94.w, height: 48.w, fit: BoxFit.cover))),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

showExample3Dialog(BuildContext context) async {
  return await showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.65),
    builder: (BuildContext context) {
      return GestureDetector(
        onTap: () async {
          Get.back();
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 66.w),
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Image.asset('assets/tutorial/tutorial_4.png', width: 113.w, height: 48.w, fit: BoxFit.cover))),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
