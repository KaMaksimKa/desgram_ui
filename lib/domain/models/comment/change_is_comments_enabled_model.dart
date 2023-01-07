import 'package:json_annotation/json_annotation.dart';

part 'change_is_comments_enabled_model.g.dart';

@JsonSerializable()
class ChangeIsCommentsEnabledModel {
  final String postId;
  final bool isCommentsEnabled;

  ChangeIsCommentsEnabledModel({
    required this.postId,
    required this.isCommentsEnabled,
  });

  factory ChangeIsCommentsEnabledModel.fromJson(Map<String, dynamic> json) =>
      _$ChangeIsCommentsEnabledModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChangeIsCommentsEnabledModelToJson(this);
}
