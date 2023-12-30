import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:ticats/data/models/ticats_member_model.dart';
import 'package:ticats/domain/entities/ticats_member.dart';

part 'member_api.g.dart';

@RestApi()
abstract class MemberAPI {
  factory MemberAPI(Dio dioBuilder) = _MemberAPI;

  @GET('/members')
  Future<void> checkNickname(@Query('nickname') String nickname);

  @GET('/members')
  Future<TicatsMemberModel> checkMember(@Query('socialId') String socialId, @Query('socialType') String socialType);

  @PATCH('/members')
  Future<Member> patchMember(@Part(contentType: "application/json") Map<String, MultipartFile> request);

  @POST('/quits/reasons')
  @MultiPart()
  Future<void> resignMember(@Part(contentType: "application/json") Map<String, MultipartFile> quits);
}
