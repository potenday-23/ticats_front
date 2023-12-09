import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:ticats/app/config/app_const.dart';
import 'package:ticats/app/network/builder/dio_builder.dart';
import 'package:ticats/app/service/auth_service.dart';
import 'package:ticats/app/service/permission_service.dart';
import 'package:ticats/data/datasources/remote/auth_api.dart';
import 'package:ticats/data/repositories_impl/auth_repository_impl.dart';
import 'package:ticats/domain/usecases/auth_use_cases.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    injectNetworkProvider();
    injectRepository();
    injectService();
    injectUseCase();
  }

  void injectNetworkProvider() {
    // Dio
    Get.lazyPut(
      () => (DioBuilder(options: BaseOptions(baseUrl: AppConst.baseUrl), withToken: false)),
      tag: DioBuilderType.withoutToken.name,
      fenix: true,
    );
    Get.lazyPut(
      () => (DioBuilder(
        options: BaseOptions(baseUrl: AppConst.baseUrl),
        refreshDio: Get.find<DioBuilder>(tag: DioBuilderType.withoutToken.name),
      )),
      tag: DioBuilderType.withToken.name,
      fenix: true,
    );

    // API
    Get.lazyPut(() => AuthAPI(Get.find<DioBuilder>(tag: DioBuilderType.withoutToken.name)), fenix: true);
  }

  void injectRepository() {
    Get.put(AuthRepositoryImpl());
  }

  void injectService() {
    Get.put(AuthService());
    Get.lazyPut(() => PermissionService(), fenix: true);
  }

  void injectUseCase() {
    Get.put(AuthUseCases());
  }
}
