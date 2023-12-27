import '../entities/notice.dart';
import '../entities/statistics.dart';

abstract class MyPageRepository {
  Future<List<Notice>> getNotices();
  Future<List<Statistics>> getStatistics();
  Future<List<YearStatistics>> getYearStatistics();
}
