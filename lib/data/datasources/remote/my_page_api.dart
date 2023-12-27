import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:ticats/data/models/notice_model.dart';
import 'package:ticats/data/models/statistics_model.dart';

part 'my_page_api.g.dart';

@RestApi()
abstract class MyPageAPI {
  factory MyPageAPI(Dio dioBuilder) = _MyPageAPI;

  @GET('/notices')
  Future<List<NoticeModel>> getNotices();

  @GET('/members/statistics')
  Future<List<StatisticsModel>> getStatistics();

  @GET('/members/year-statistics')
  Future<List<YearStatisticsModel>> getYearStatistics();
}
