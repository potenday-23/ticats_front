import 'package:auto_mappr_annotation/auto_mappr_annotation.dart';
import 'package:ticats/data/models/category_model.dart';
import 'package:ticats/domain/entities/category.dart';

import 'category_mapper.auto_mappr.dart';

@AutoMappr([
  MapType<CategoryModel, Category>(),
])
class CategoryMappr extends $CategoryMappr {}
