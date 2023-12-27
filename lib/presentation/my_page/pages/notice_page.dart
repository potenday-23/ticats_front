import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ticats/app/config/app_color.dart';
import 'package:ticats/app/config/app_typeface.dart';
import 'package:ticats/app/config/routes/route_path.dart';
import 'package:ticats/domain/entities/notice.dart';
import 'package:ticats/domain/usecases/my_page_use_cases.dart';
import 'package:ticats/presentation/common/widgets/ticats_appbar.dart';

class NoticePage extends StatelessWidget {
  const NoticePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CloseAppBar(title: "공지사항"),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 28.h),
        child: FutureBuilder(
          future: MyPageUseCases().getNoticeUseCase.execute(),
          builder: (BuildContext context, AsyncSnapshot<List<Notice>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            if (snapshot.hasError) return const Center(child: Text("에러가 발생했습니다."));

            return SingleChildScrollView(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => Get.toNamed(RoutePath.noticeDetail, arguments: snapshot.data![index]),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 11.h),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    snapshot.data![index].title,
                                    style: AppTypeFace.xSmall16SemiBold,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Text(DateFormat('yy.MM.dd').format(snapshot.data![index].createdDate),
                                    style: AppTypeFace.xSmall12Regular.copyWith(color: const Color(0xFF212121))),
                              ],
                            ),
                          ),
                        ),
                        const Divider(thickness: 1, color: AppColor.grayE5),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class NoticeDetailPage extends StatelessWidget {
  NoticeDetailPage({super.key});

  final Notice _notice = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(title: _notice.title),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 44.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_notice.content, style: AppTypeFace.xSmall16SemiBold),
            SizedBox(height: 16.w),
            Align(
              alignment: Alignment.centerRight,
              child: Text(DateFormat('yy.MM.dd').format(_notice.createdDate),
                  style: AppTypeFace.xSmall12Regular.copyWith(color: const Color(0xFF212121))),
            ),
          ],
        ),
      ),
    );
  }
}
