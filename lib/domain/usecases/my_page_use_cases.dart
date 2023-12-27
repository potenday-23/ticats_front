import 'package:get/get.dart';
import 'package:ticats/domain/repositories/my_page_repository.dart';

import '../entities/notice.dart';
import '../entities/statistics.dart';

class MyPageUseCases {
  final MyPageRepository _repository = Get.find<MyPageRepository>();

  GetNoticeUseCase get getNoticeUseCase => Get.put(GetNoticeUseCase(_repository));
  GetStatisticsUseCase get getStatisticsUseCase => Get.put(GetStatisticsUseCase(_repository));
  GetYearStatisticsUseCase get getYearStatisticsUseCase => Get.put(GetYearStatisticsUseCase(_repository));
}

class GetNoticeUseCase {
  final MyPageRepository _repository;
  GetNoticeUseCase(this._repository);

  Future<List<Notice>> execute() async {
    List<Notice> result = await _repository.getNotices();

    return result;
  }
}

class GetStatisticsUseCase {
  final MyPageRepository _repository;
  GetStatisticsUseCase(this._repository);

  Future<List<Statistics>> execute() async {
    List<Statistics> result = await _repository.getStatistics();

    return result;
  }
}

class GetYearStatisticsUseCase {
  final MyPageRepository _repository;
  GetYearStatisticsUseCase(this._repository);

  Future<List<YearStatistics>> execute() async {
    List<YearStatistics> result = await _repository.getYearStatistics();

    return result;
  }
}
