import 'package:json_annotation/json_annotation.dart';

import '../post/partial_post_model.dart';
import '../user/partial_user_model.dart';

part 'like_comment_notification_model.g.dart';

@JsonSerializable()
class LikeCommentNotificationModel {
  final PartialUserModel user;
  final PartialPostModel post;
  final String comment;

  LikeCommentNotificationModel({
    required this.user,
    required this.post,
    required this.comment,
  });

  factory LikeCommentNotificationModel.fromJson(Map<String, dynamic> json) =>
      _$LikeCommentNotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$LikeCommentNotificationModelToJson(this);
}
