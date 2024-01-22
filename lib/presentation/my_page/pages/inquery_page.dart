import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ticats/app/config/app_const.dart';

import 'package:ticats/app/config/app_typeface.dart';
import 'package:ticats/app/util/email_util.dart';
import 'package:ticats/app/util/ga_util.dart';
import 'package:ticats/presentation/common/widgets/ticats_appbar.dart';
import 'package:ticats/presentation/common/widgets/ticats_button.dart';
import 'package:ticats/presentation/common/widgets/ticats_dialog.dart';

class InqueryPage extends StatelessWidget {
  const InqueryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CloseAppBar(title: "문의하기"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 150.h),
            Text('"${AppConst.ticatsEmail}"', style: AppTypeFace.small20Bold),
            SizedBox(height: 24.h),
            Text("앱에 대한 문의 및 건의사항을\n보내주세요 :)", style: AppTypeFace.small20Bold, textAlign: TextAlign.center),
            SizedBox(height: 117.h),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 31.16.w),
                child: SvgPicture.asset('assets/cats/cat_inquery.svg', width: 88.83.w, height: 143.43497.h),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
            padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.w),
            child: TicatsButton(
              child: Text("이메일 보내기", style: AppTypeFace.small18Bold.copyWith(color: Colors.white)),
              onPressed: () async {
                try {
                  await EmailUtil().sendInqueryEmail();
                } catch (e) {
                  if (context.mounted) await showErrorDialog(context);
                  debugPrint(e.toString());
                } finally {
                  await GAUtil().sendGAButtonEvent('inquery_button', {});
                }
              },
            )),
      ),
    );
  }
}
