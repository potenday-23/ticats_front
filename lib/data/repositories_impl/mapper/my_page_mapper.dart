import 'package:auto_mappr_annotation/auto_mappr_annotation.dart';
import 'package:ticats/data/models/notice_model.dart';
import 'package:ticats/data/models/statistics_model.dart';
import 'package:ticats/data/models/version_model.dart';
import 'package:ticats/domain/entities/notice.dart';
import 'package:ticats/domain/entities/statistics.dart';
import 'package:ticats/domain/entities/version.dart';

import 'my_page_mapper.auto_mappr.dart';

@AutoMappr([
  MapType<NoticeModel, Notice>(),
  MapType<StatisticsModel, Statistics>(),
  MapType<VersionModel, Version>(),
  MapType<YearStatisticsModel, YearStatistics>(),
])
class MyPageMappr extends $MyPageMappr {}
