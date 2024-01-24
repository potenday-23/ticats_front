import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ticats/presentation/common/enum/term_type.dart';
import 'package:ticats/presentation/common/widgets/ticats_appbar.dart';

class TermDetailPage extends StatelessWidget {
  TermDetailPage({super.key});

  final TermType termType = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CloseAppBar(title: termType.termName),
      body: FutureBuilder(
        future: rootBundle.loadString("assets/terms/${termType.fileName}.md"),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Markdown(
                data: snapshot.data,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.w),
                physics: const ClampingScrollPhysics(),
                styleSheet: MarkdownStyleSheet(
                  strong: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, height: 1.3),
                  p: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500, height: 1.2),
                  listBullet: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500, height: 1),
                  listBulletPadding: EdgeInsets.zero,
                ));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
