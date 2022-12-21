import 'package:json_annotation/json_annotation.dart';

part 'update_comment_model.g.dart';

@JsonSerializable()
class UpdateCommentModel {
  final String commentId;
  final String content;

  UpdateCommentModel({
    required this.commentId,
    required this.content,
  });

  factory UpdateCommentModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateCommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateCommentModelToJson(this);
}
