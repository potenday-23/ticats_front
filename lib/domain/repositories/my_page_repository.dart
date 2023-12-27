import '../entities/notice.dart';
import '../entities/statistics.dart';

abstract class MyPageRepository {
  Future<List<Notice>> getNotices();
  Future<List<Statistics>> getStatistics(String month);
  Future<List<YearStatistics>> getYearStatistics();
}
