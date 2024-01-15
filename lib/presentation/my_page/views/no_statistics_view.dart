import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticats/app/config/app_color.dart';
import 'package:ticats/app/config/app_typeface.dart';

class NoStatisticsView extends StatelessWidget {
  const NoStatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _ChartWidget(),
        _FavoriteCategoryWidget(),
      ],
    );
  }
}

class _FavoriteCategoryWidget extends StatelessWidget {
  const _FavoriteCategoryWidget();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24.h),
          Text("아직 티켓을 등록하지 않았어요.", style: AppTypeFace.small18SemiBold),
          SizedBox(height: 36.h),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              color: AppColor.grayF2,
            ),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Center(child: Text("등록된 티켓이 없어요.", style: AppTypeFace.xSmall16SemiBold)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartWidget extends StatelessWidget {
  const _ChartWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      color: Colors.white,
      child: Column(
        children: [
          DropdownButton(
            value: 0,
            items: [DropdownMenuItem(value: 0, child: Text('${DateTime.now().year}년 ${DateTime.now().month}월'))],
            onChanged: (value) async {},
            underline: const SizedBox(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.h),
            child: SizedBox(
              width: 250.w,
              height: 250.w,
              child: PieChart(
                PieChartData(
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 37.5.w,
                  sections: [
                    PieChartSectionData(
                      color: AppColor.grayF2,
                      value: 100,
                      radius: 92.5,
                      title: '',
                    )
                  ],
                  startDegreeOffset: 270,
                ),
              ),
            ),
          ),
          SizedBox(height: 26.h),
          const Divider(thickness: 1, height: 1, color: AppColor.grayE5),
        ],
      ),
    );
  }
}
