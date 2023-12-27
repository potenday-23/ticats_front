import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:ticats/app/config/app_typeface.dart';
import 'package:ticats/app/util/email_util.dart';
import 'package:ticats/presentation/common/widgets/ticats_appbar.dart';
import 'package:ticats/presentation/common/widgets/ticats_button.dart';

class InqueryPage extends StatelessWidget {
  const InqueryPage({super.key});

  Future<void> _showErrorDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog.adaptive(
          title: const Text('이메일 전송 실패'),
          content: const Text('기본 메일 앱을 사용할 수 없어요.\n\n아래 이메일로 연락주시면 친절하게 답변해드릴게요.\n\nwonhee0619@gmail.com'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

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
            Text('"wonhee0619@gmail.com"', style: AppTypeFace.small20Bold),
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
              child: Text("이메일 보내기", style: AppTypeFace.small20Bold.copyWith(color: Colors.white)),
              onPressed: () async {
                try {
                  EmailUtil().sendInqueryEmail();
                  await _showErrorDialog(context);
                } catch (e) {
                  print(e);
                }
              },
            )),
      ),
    );
  }
}
