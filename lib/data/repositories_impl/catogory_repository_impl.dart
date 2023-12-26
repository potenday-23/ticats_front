import 'package:get/get.dart';
import 'package:ticats/domain/entities/category.dart';

import 'package:ticats/domain/repositories/category_repository.dart';

import '../datasources/remote/category_api.dart';
import '../models/category_model.dart';
import 'mapper/category_mapper.dart';

final CategoryMappr _categoryMappr = CategoryMappr();

class CategoryRepositoryImpl extends CategoryRepository {
  final CategoryAPI _api = Get.find();

  @override
  Future<List<Category>> getCategories() async {
    var categoryList = await _api.getCategories();

    return _categoryMappr.convertList<CategoryModel, Category>(categoryList);
  }
}
