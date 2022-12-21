// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_is_comments_enabled_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangeIsCommentsEnabledModel _$ChangeIsCommentsEnabledModelFromJson(
        Map<String, dynamic> json) =>
    ChangeIsCommentsEnabledModel(
      postId: json['postId'] as String,
      isCommentsEnabled: json['isCommentsEnabled'] as bool,
    );

Map<String, dynamic> _$ChangeIsCommentsEnabledModelToJson(
        ChangeIsCommentsEnabledModel instance) =>
    <String, dynamic>{
      'postId': instance.postId,
      'isCommentsEnabled': instance.isCommentsEnabled,
    };
