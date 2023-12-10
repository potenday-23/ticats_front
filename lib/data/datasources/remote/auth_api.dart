import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:ticats/data/models/ticats_member_model.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthAPI {
  factory AuthAPI(Dio dioBuilder) = _AuthAPI;

  @POST('/auth/login')
  @MultiPart()
  Future<TicatsMemberModel> login(@Part(contentType: "application/json") Map<String, MultipartFile> request);

  @POST('/auth/login')
  @MultiPart()
  Future<TicatsMemberModel> register(@Part(contentType: "application/json") Map<String, MultipartFile> request);
}
