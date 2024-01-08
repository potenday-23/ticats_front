import 'package:ticats/domain/entities/version.dart';

import '../entities/notice.dart';
import '../entities/statistics.dart';

abstract class MyPageRepository {
  Future<List<Notice>> getNotices();
  Future<List<Statistics>> getStatistics(String month);
  Future<Version> getVersions();
  Future<List<YearStatistics>> getYearStatistics();
}
