import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:ticats/app/config/app_const.dart';
import 'package:ticats/app/network/builder/dio_builder.dart';
import 'package:ticats/app/service/auth_service.dart';
import 'package:ticats/app/service/permission_service.dart';
import 'package:ticats/app/service/ticats_service.dart';
import 'package:ticats/data/datasources/remote/auth_api.dart';
import 'package:ticats/data/datasources/remote/category_api.dart';
import 'package:ticats/data/datasources/remote/like_api.dart';
import 'package:ticats/data/datasources/remote/member_api.dart';
import 'package:ticats/data/datasources/remote/my_page_api.dart';
import 'package:ticats/data/datasources/remote/ticket_api.dart';
import 'package:ticats/data/repositories_impl/auth_repository_impl.dart';
import 'package:ticats/data/repositories_impl/catogory_repository_impl.dart';
import 'package:ticats/data/repositories_impl/like_repository_impl.dart';
import 'package:ticats/data/repositories_impl/member_repository_impl.dart';
import 'package:ticats/data/repositories_impl/my_page_repository_impl.dart';
import 'package:ticats/data/repositories_impl/ticket_repository_impl.dart';
import 'package:ticats/domain/repositories/auth_repository.dart';
import 'package:ticats/domain/repositories/category_repository.dart';
import 'package:ticats/domain/repositories/like_repository.dart';
import 'package:ticats/domain/repositories/member_repository.dart';
import 'package:ticats/domain/repositories/my_page_repository.dart';
import 'package:ticats/domain/repositories/ticket_repository.dart';
import 'package:ticats/domain/usecases/auth_use_cases.dart';
import 'package:ticats/domain/usecases/category_use_cases.dart';
import 'package:ticats/domain/usecases/like_use_cases.dart';
import 'package:ticats/domain/usecases/member_use_cases.dart';
import 'package:ticats/domain/usecases/my_page_use_cases.dart';
import 'package:ticats/domain/usecases/ticket_use_cases.dart';

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
    Get.lazyPut(() => CategoryAPI(Get.find<DioBuilder>(tag: DioBuilderType.withoutToken.name)), fenix: true);
    Get.lazyPut(() => LikeAPI(Get.find<DioBuilder>(tag: DioBuilderType.withToken.name)), fenix: true);
    Get.lazyPut(() => MemberAPI(Get.find<DioBuilder>(tag: DioBuilderType.withToken.name)), fenix: true);
    Get.lazyPut(() => MyPageAPI(Get.find<DioBuilder>(tag: DioBuilderType.withToken.name)), fenix: true);
    Get.lazyPut(() => TicketAPI(Get.find<DioBuilder>(tag: DioBuilderType.withToken.name)), fenix: true);
  }

  void injectRepository() {
    Get.put<AuthRepository>(AuthRepositoryImpl());
    Get.put<CategoryRepository>(CategoryRepositoryImpl());
    Get.put<LikeRepository>(LikeRepositoryImpl());
    Get.put<MemberRepository>(MemberRepositoryImpl());
    Get.put<MyPageRepository>(MyPageRepositoryImpl());
    Get.put<TicketRepository>(TicketRepositoryImpl());
  }

  void injectService() {
    Get.put(AuthService());
    Get.put(TicatsService());
    Get.lazyPut(() => PermissionService(), fenix: true);
  }

  void injectUseCase() {
    Get.put(AuthUseCases());
    Get.put(CategoryUseCases());
    Get.put(LikeUseCases());
    Get.put(MemberUseCases());
    Get.put(MyPageUseCases());
    Get.put(TicketUseCases());
  }
}
