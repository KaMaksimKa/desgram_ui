import 'package:json_annotation/json_annotation.dart';

part 'create_comment_model.g.dart';

@JsonSerializable()
class CreateCommentModel {
  final String postId;
  final String content;

  CreateCommentModel({
    required this.postId,
    required this.content,
  });

  factory CreateCommentModel.fromJson(Map<String, dynamic> json) =>
      _$CreateCommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateCommentModelToJson(this);
}
