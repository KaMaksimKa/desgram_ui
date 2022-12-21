// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_likes_visibility_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangeLikesVisibilityModel _$ChangeLikesVisibilityModelFromJson(
        Map<String, dynamic> json) =>
    ChangeLikesVisibilityModel(
      postId: json['postId'] as String,
      isLikesVisible: json['isLikesVisible'] as bool,
    );

Map<String, dynamic> _$ChangeLikesVisibilityModelToJson(
        ChangeLikesVisibilityModel instance) =>
    <String, dynamic>{
      'postId': instance.postId,
      'isLikesVisible': instance.isLikesVisible,
    };
