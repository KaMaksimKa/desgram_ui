// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentNotificationModel _$CommentNotificationModelFromJson(
        Map<String, dynamic> json) =>
    CommentNotificationModel(
      user: PartialUserModel.fromJson(json['user'] as Map<String, dynamic>),
      post: PartialPostModel.fromJson(json['post'] as Map<String, dynamic>),
      content: json['content'] as String,
    );

Map<String, dynamic> _$CommentNotificationModelToJson(
        CommentNotificationModel instance) =>
    <String, dynamic>{
      'user': instance.user,
      'post': instance.post,
      'content': instance.content,
    };
