// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like_post_notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LikePostNotificationModel _$LikePostNotificationModelFromJson(
        Map<String, dynamic> json) =>
    LikePostNotificationModel(
      user: PartialUserModel.fromJson(json['user'] as Map<String, dynamic>),
      post: PartialPostModel.fromJson(json['post'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LikePostNotificationModelToJson(
        LikePostNotificationModel instance) =>
    <String, dynamic>{
      'user': instance.user,
      'post': instance.post,
    };
