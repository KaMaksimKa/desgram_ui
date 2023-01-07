// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like_comment_notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LikeCommentNotificationModel _$LikeCommentNotificationModelFromJson(
        Map<String, dynamic> json) =>
    LikeCommentNotificationModel(
      user: PartialUserModel.fromJson(json['user'] as Map<String, dynamic>),
      post: PartialPostModel.fromJson(json['post'] as Map<String, dynamic>),
      comment: json['comment'] as String,
    );

Map<String, dynamic> _$LikeCommentNotificationModelToJson(
        LikeCommentNotificationModel instance) =>
    <String, dynamic>{
      'user': instance.user,
      'post': instance.post,
      'comment': instance.comment,
    };
