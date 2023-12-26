import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:ticats/data/models/category_model.dart';

part 'category_api.g.dart';

@RestApi()
abstract class CategoryAPI {
  factory CategoryAPI(Dio dioBuilder) = _CategoryAPI;

  @GET('/categorys')
  Future<List<CategoryModel>> getCategories();
}
