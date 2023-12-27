import 'package:get/get.dart';

import 'package:ticats/domain/entities/notice.dart';
import 'package:ticats/domain/entities/statistics.dart';
import 'package:ticats/domain/repositories/my_page_repository.dart';

import '../datasources/remote/my_page_api.dart';
import '../models/notice_model.dart';
import '../models/statistics_model.dart';
import 'mapper/my_page_mapper.dart';

final MyPageMappr _myPageMappr = MyPageMappr();

class MyPageRepositoryImpl extends MyPageRepository {
  final MyPageAPI _api = Get.find();

  @override
  Future<List<Notice>> getNotices() async {
    List<NoticeModel> noticeList = await _api.getNotices();

    return _myPageMappr.convertList<NoticeModel, Notice>(noticeList);
  }

  @override
  Future<List<Statistics>> getStatistics(String month) async {
    List<StatisticsModel> statisticsList = await _api.getStatistics(month);

    return _myPageMappr.convertList<StatisticsModel, Statistics>(statisticsList);
  }

  @override
  Future<List<YearStatistics>> getYearStatistics() async {
    List<YearStatisticsModel> yearStatisticsList = await _api.getYearStatistics();

    return _myPageMappr.convertList<YearStatisticsModel, YearStatistics>(yearStatisticsList);
  }
}
