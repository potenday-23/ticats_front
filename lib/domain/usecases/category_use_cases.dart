import 'package:get/get.dart';
import 'package:ticats/domain/repositories/category_repository.dart';

import '../entities/category.dart';

class CategoryUseCases {
  final CategoryRepository _repository = Get.find<CategoryRepository>();

  GetCategoriesUseCase get getCategoriesUseCase => Get.put(GetCategoriesUseCase(_repository));
}

class GetCategoriesUseCase {
  final CategoryRepository _repository;
  GetCategoriesUseCase(this._repository);

  Future<List<Category>> execute() async {
    List<Category> result = await _repository.getCategories();

    return result;
  }
}
