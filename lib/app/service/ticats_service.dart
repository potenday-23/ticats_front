import 'package:get/get.dart';
import 'package:ticats/domain/entities/category.dart';
import 'package:ticats/domain/usecases/category_use_cases.dart';

class TicatsService extends GetxService {
  static TicatsService get to => Get.find();

  List<Category> ticatsCategories = [];

  @override
  void onInit() async {
    super.onInit();
    await getCategories();
  }

  Future<void> getCategories() async {
    ticatsCategories = await CategoryUseCases().getCategoriesUseCase.execute();
  }
}
