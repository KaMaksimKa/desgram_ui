// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_avatar_candidate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAvatarCandidate _$UserAvatarCandidateFromJson(Map<String, dynamic> json) =>
    UserAvatarCandidate(
      id: json['id'] as String,
      width: json['width'] as int,
      height: json['height'] as int,
      url: json['url'] as String,
      mimeType: json['mimeType'] as String,
      userAvatarId: json['userAvatarId'] as String,
    );

Map<String, dynamic> _$UserAvatarCandidateToJson(
        UserAvatarCandidate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'width': instance.width,
      'height': instance.height,
      'url': instance.url,
      'mimeType': instance.mimeType,
      'userAvatarId': instance.userAvatarId,
    };
