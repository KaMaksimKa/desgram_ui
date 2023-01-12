import 'package:desgram_ui/domain/models/user/partial_user_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../post/partial_post_model.dart';

part 'comment_notification_model.g.dart';

@JsonSerializable()
class CommentNotificationModel {
  final PartialUserModel user;
  final PartialPostModel post;
  final String content;

  CommentNotificationModel({
    required this.user,
    required this.post,
    required this.content,
  });

  factory CommentNotificationModel.fromJson(Map<String, dynamic> json) =>
      _$CommentNotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentNotificationModelToJson(this);
}
