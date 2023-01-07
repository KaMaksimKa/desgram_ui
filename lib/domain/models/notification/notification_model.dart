import 'package:desgram_ui/domain/models/notification/subscription_notification_model.dart';
import 'package:json_annotation/json_annotation.dart';

import 'comment_notification_model.dart';
import 'like_comment_notification_model.dart';
import 'like_post_notification_model.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  final DateTime createdDate;
  final bool hasViewed;
  final LikePostNotificationModel? likePost;
  final LikeCommentNotificationModel? likeComment;
  final CommentNotificationModel? comment;
  final SubscriptionNotificationModel? subscription;

  NotificationModel({
    required this.createdDate,
    required this.hasViewed,
    this.likePost,
    this.likeComment,
    this.comment,
    this.subscription,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}
