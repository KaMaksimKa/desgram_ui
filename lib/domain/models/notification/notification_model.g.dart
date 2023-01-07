// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      createdDate: DateTime.parse(json['createdDate'] as String),
      hasViewed: json['hasViewed'] as bool,
      likePost: json['likePost'] == null
          ? null
          : LikePostNotificationModel.fromJson(
              json['likePost'] as Map<String, dynamic>),
      likeComment: json['likeComment'] == null
          ? null
          : LikeCommentNotificationModel.fromJson(
              json['likeComment'] as Map<String, dynamic>),
      comment: json['comment'] == null
          ? null
          : CommentNotificationModel.fromJson(
              json['comment'] as Map<String, dynamic>),
      subscription: json['subscription'] == null
          ? null
          : SubscriptionNotificationModel.fromJson(
              json['subscription'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'createdDate': instance.createdDate.toIso8601String(),
      'hasViewed': instance.hasViewed,
      'likePost': instance.likePost,
      'likeComment': instance.likeComment,
      'comment': instance.comment,
      'subscription': instance.subscription,
    };
