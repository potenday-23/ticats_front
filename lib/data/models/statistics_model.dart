import 'package:freezed_annotation/freezed_annotation.dart';

part 'statistics_model.freezed.dart';
part 'statistics_model.g.dart';

@freezed
class StatisticsModel with _$StatisticsModel {
  const factory StatisticsModel({
    required String category,
    required int categoryCnt,
    required double categoryPercent,
  }) = _StatisticsModel;

  factory StatisticsModel.fromJson(Map<String, Object?> json) => _$StatisticsModelFromJson(json);
}

@freezed
class YearStatisticsModel with _$YearStatisticsModel {
  const factory YearStatisticsModel({
    required int year,
    required int month,
    required int count,
  }) = _YearStatisticsModel;

  factory YearStatisticsModel.fromJson(Map<String, Object?> json) => _$YearStatisticsModelFromJson(json);
}
