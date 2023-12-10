import 'dart:convert';

import 'package:image_picker/image_picker.dart';

class RegisterEntity {
  String? socialId;
  String? socialType;
  String? profileUrl;
  String? nickname;
  String? pushAgree;
  String? marketingAgree;
  XFile? profileImage;
  List<String>? categorys;

  RegisterEntity({
    this.socialId,
    this.socialType,
    this.profileUrl,
    this.nickname,
    this.pushAgree,
    this.marketingAgree,
    this.profileImage,
    this.categorys,
  });

  @override
  String toString() {
    return 'RegisterEntity(socialId: $socialId, socialType: $socialType, profileUrl: $profileUrl, nickname: $nickname, pushAgree: $pushAgree, marketingAgree: $marketingAgree, profileImage: $profileImage, categorys: $categorys)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'socialId': socialId,
      'socialType': socialType,
      'profileUrl': profileUrl,
      'nickname': nickname,
      'pushAgree': pushAgree,
      'marketingAgree': marketingAgree,
      'profileImage': profileImage,
      'categorys': categorys,
    };
  }

  factory RegisterEntity.fromMap(Map<String, dynamic> map) {
    return RegisterEntity(
      socialId: map['socialId'] != null ? map['socialId'] as String : null,
      socialType: map['socialType'] != null ? map['socialType'] as String : null,
      profileUrl: map['profileUrl'] != null ? map['profileUrl'] as String : null,
      nickname: map['nickname'] != null ? map['nickname'] as String : null,
      pushAgree: map['pushAgree'] != null ? map['pushAgree'] as String : null,
      marketingAgree: map['marketingAgree'] != null ? map['marketingAgree'] as String : null,
      profileImage: map['profileImage'] != null ? map['profileImage'] as XFile : null,
      categorys: map['categorys'] != null ? List<String>.from((map['categorys'] as List<String>)) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RegisterEntity.fromJson(String source) => RegisterEntity.fromMap(json.decode(source) as Map<String, dynamic>);
}
