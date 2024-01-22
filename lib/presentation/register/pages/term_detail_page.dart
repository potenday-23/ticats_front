import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ticats/app/config/app_typeface.dart';
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
                padding: EdgeInsets.symmetric(horizontal: 44.w, vertical: 36.w),
                physics: const ClampingScrollPhysics(),
                styleSheet: MarkdownStyleSheet(
                  strong: AppTypeFace.xSmall14Medium,
                  p: AppTypeFace.xSmall14Medium,
                  listBullet: AppTypeFace.xSmall14Medium,
                  blockSpacing: 2,
                ));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
