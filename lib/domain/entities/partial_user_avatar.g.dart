// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partial_user_avatar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartialUserAvatar _$PartialUserAvatarFromJson(Map<String, dynamic> json) =>
    PartialUserAvatar(
      id: json['id'] as String,
      width: json['width'] as int,
      height: json['height'] as int,
      url: json['url'] as String,
      mimeType: json['mimeType'] as String,
      partialUserId: json['partialUserId'] as String,
    );

Map<String, dynamic> _$PartialUserAvatarToJson(PartialUserAvatar instance) =>
    <String, dynamic>{
      'id': instance.id,
      'width': instance.width,
      'height': instance.height,
      'url': instance.url,
      'mimeType': instance.mimeType,
      'partialUserId': instance.partialUserId,
    };
