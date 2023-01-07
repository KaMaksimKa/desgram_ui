import 'package:desgram_ui/domain/models/post/partial_post_model.dart';
import 'package:desgram_ui/domain/models/user/partial_user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'like_post_notification_model.g.dart';

@JsonSerializable()
class LikePostNotificationModel {
  final PartialUserModel user;
  final PartialPostModel post;

  LikePostNotificationModel({
    required this.user,
    required this.post,
  });

  factory LikePostNotificationModel.fromJson(Map<String, dynamic> json) =>
      _$LikePostNotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$LikePostNotificationModelToJson(this);
}
