import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:ticats/data/models/user_model.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthAPI {
  factory AuthAPI(Dio dioBuilder) = _AuthAPI;

  @GET('/members')
  Future<void> checkNickname(@Query('nickname') String nickname);

  @GET('/members')
  Future<UserModel> checkUser(@Query('socialId') String socialId, @Query('socialType') String socialType);

  @POST('/auth/login')
  @MultiPart()
  Future<UserModel> login(@Part(contentType: "application/json") Map<String, MultipartFile> request);
}
