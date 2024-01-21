import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ticats/app/config/app_color.dart';
import 'package:ticats/app/config/app_typeface.dart';
import 'package:ticats/domain/entities/statistics.dart';
import 'package:ticats/presentation/common/widgets/ticats_appbar.dart';
import 'package:ticats/presentation/my_page/controller/statistic_controller.dart';
import 'package:ticats/presentation/my_page/views/no_statistics_view.dart';

final List<Color> pieColors = [
  const Color(0xFFF683BB),
  const Color(0xFFF89CC9),
  const Color(0xFFFAB5D6),
  const Color(0xFFFBCDE4),
  const Color(0xFFC7C7CC),
  const Color(0xFFD9D9E1),
  const Color(0xFFE5E5EA),
  const Color(0xFFF7F2F2),
];

class StatisticsPage extends GetView<StatisticController> {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(title: "통계"),
      body: Obx(() {
        if (controller.isStatisticLoading.value) return const Center(child: CircularProgressIndicator());
        if (controller.statisticsList.isEmpty) return const Center(child: NoStatisticsView());

        return SingleChildScrollView(
          controller: controller.scrollController,
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              const _ChartWidget(),
              const _FavoriteCategoryWidget(),
              SizedBox(height: 65.h),
            ],
          ),
        );
      }),
    );
  }
}

class _FavoriteCategoryWidget extends GetView<StatisticController> {
  const _FavoriteCategoryWidget();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24.h),
          Text("이번 달엔 ${controller.statisticsList[0].category}를 가장 많이 봤어요", style: AppTypeFace.small18SemiBold),
          SizedBox(height: 36.h),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              color: AppColor.grayF2,
            ),
            child: Obx(
              () => Column(
                children: [
                  if (!controller.isStatisticOpen.value) ...[
                    for (int i = 0; i < controller.statisticsList.length; i++) ...[
                      if (i < 3)
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(16.w),
                              child: Row(
                                children: [
                                  Text(controller.statisticsList[i].category, style: AppTypeFace.xSmall16SemiBold),
                                  const Spacer(),
                                  Text('${controller.statisticsList[i].categoryCnt}회', style: AppTypeFace.xSmall16SemiBold),
                                ],
                              ),
                            ),
                            if (i != controller.statisticsList.length - 1)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: const Divider(height: 1, thickness: 1, color: AppColor.grayE5),
                              ),
                          ],
                        ),
                    ],
                    if (controller.statisticsList.length > 3)
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          controller.isStatisticOpen.value = true;

                          Future.delayed(const Duration(milliseconds: 50), () {
                            controller.scrollController.animateTo(
                              controller.scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOut,
                            );
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Center(child: Text('펼치기', style: AppTypeFace.xSmall14Medium)),
                        ),
                      ),
                  ] else ...[
                    for (int i = 0; i < controller.statisticsList.length; i++) ...[
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Row(
                              children: [
                                Text(controller.statisticsList[i].category, style: AppTypeFace.xSmall16SemiBold),
                                const Spacer(),
                                Text('${controller.statisticsList[i].categoryCnt}회', style: AppTypeFace.xSmall16SemiBold),
                              ],
                            ),
                          ),
                          if (i != controller.statisticsList.length)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: const Divider(height: 1, thickness: 1, color: AppColor.grayE5),
                            ),
                        ],
                      ),
                    ],
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => controller.isStatisticOpen.value = false,
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Center(child: Text('닫기', style: AppTypeFace.xSmall14Medium)),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartWidget extends GetView<StatisticController> {
  const _ChartWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      color: Colors.white,
      child: Obx(
        () => Column(
          children: [
            DropdownButton2(
              value: controller.selectedMonth.value,
              items: controller.yearStatisticsList.map<DropdownMenuItem<YearStatistics>>((YearStatistics value) {
                return DropdownMenuItem(value: value, child: Text('${value.year}년 ${value.month}월'));
              }).toList(),
              onChanged: (value) async {
                controller.selectedMonth.value = value!;
                await controller.getStatistics(
                    "${controller.selectedMonth.value.year}-${controller.selectedMonth.value.month.toString().padLeft(2, '0')}");
              },
              underline: const SizedBox(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h),
              child: SizedBox(
                width: 250.w,
                height: 250.w,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                          controller.touchedIndex.value = -1;
                          return;
                        }
                        controller.touchedIndex.value = pieTouchResponse.touchedSection!.touchedSectionIndex;
                      },
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 37.5.w,
                    sections: _showingSections(),
                    startDegreeOffset: 270,
                  ),
                ),
              ),
            ),
            SizedBox(height: 26.h),
            const Divider(thickness: 1, height: 1, color: AppColor.grayE5),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _showingSections() {
    return List.generate(controller.statisticsList.length, (i) {
      final isTouched = i == controller.touchedIndex.value;
      final radius = isTouched ? 100.w : 92.5.w;

      return PieChartSectionData(
        color: pieColors[i],
        value: controller.statisticsList[i].categoryPercent,
        title: controller.statisticsList[i].categoryPercent < 10
            ? '${controller.statisticsList[i].categoryPercent.toStringAsFixed(1)}%'
            : '${controller.statisticsList[i].category}\n${controller.statisticsList[i].categoryPercent.toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: AppTypeFace.xSmall16SemiBold,
      );
    });
  }
}
