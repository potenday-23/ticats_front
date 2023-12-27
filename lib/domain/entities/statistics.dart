import 'package:freezed_annotation/freezed_annotation.dart';

part 'statistics.freezed.dart';
part 'statistics.g.dart';

@freezed
class Statistics with _$Statistics {
  const factory Statistics({
    required String category,
    required int categoryCnt,
    required double categoryPercent,
  }) = _Statistics;

  factory Statistics.fromJson(Map<String, Object?> json) => _$StatisticsFromJson(json);
}

@freezed
class YearStatistics with _$YearStatistics {
  const factory YearStatistics({
    required int year,
    required int month,
    required int count,
  }) = _YearStatistics;

  factory YearStatistics.fromJson(Map<String, Object?> json) => _$YearStatisticsFromJson(json);
}
