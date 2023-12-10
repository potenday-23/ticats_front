import 'package:auto_mappr_annotation/auto_mappr_annotation.dart';
import 'package:ticats/data/models/ticats_member_model.dart';
import 'package:ticats/domain/entities/ticats_member.dart';

import 'member_mapper.auto_mappr.dart';

@AutoMappr([
  MapType<TicatsMemberModel, TicatsMember>(),
  MapType<TokenModel, Token>(),
  MapType<MemberModel, Member>(),
])
class MemberMapper extends $MemberMapper {}
