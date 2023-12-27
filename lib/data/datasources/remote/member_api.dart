import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:ticats/data/models/ticats_member_model.dart';

part 'member_api.g.dart';

@RestApi()
abstract class MemberAPI {
  factory MemberAPI(Dio dioBuilder) = _MemberAPI;

  @GET('/members')
  Future<void> checkNickname(@Query('nickname') String nickname);

  @GET('/members')
  Future<TicatsMemberModel> checkMember(@Query('socialId') String socialId, @Query('socialType') String socialType);

  @DELETE('/members')
  Future<void> resignMember();
}
