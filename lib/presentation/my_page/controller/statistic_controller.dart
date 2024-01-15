import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ticats/domain/entities/statistics.dart';
import 'package:ticats/domain/usecases/my_page_use_cases.dart';

class StatisticController extends GetxController {
  final MyPageUseCases _myPageUseCases = Get.find<MyPageUseCases>();
  GetStatisticsUseCase get getStatisticsUseCase => _myPageUseCases.getStatisticsUseCase;
  GetYearStatisticsUseCase get getYearStatisticsUseCase => _myPageUseCases.getYearStatisticsUseCase;

  final RxList<YearStatistics> yearStatisticsList = <YearStatistics>[].obs;
  final RxList<Statistics> statisticsList = <Statistics>[].obs;

  RxInt touchedIndex = (-1).obs;
  RxBool isStatisticLoading = true.obs;
  RxBool isStatisticOpen = false.obs;

  late Rx<YearStatistics> selectedMonth;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() async {
    super.onInit();

    try {
      await getYearStatistics().then(
        (_) async => getStatistics("${yearStatisticsList[0].year}-${yearStatisticsList[0].month.toString().padLeft(2, '0')}"),
      );
      selectedMonth = yearStatisticsList[0].obs;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      isStatisticLoading.value = false;
    }
  }

  Future<void> getStatistics(String month) async {
    try {
      statisticsList.assignAll(await getStatisticsUseCase.execute(month));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> getYearStatistics() async {
    try {
      isStatisticLoading.value = true;

      yearStatisticsList.assignAll(await getYearStatisticsUseCase.execute());

      yearStatisticsList.sort((a, b) => b.year.compareTo(a.year));
      yearStatisticsList.sort((a, b) => b.month.compareTo(a.month));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
