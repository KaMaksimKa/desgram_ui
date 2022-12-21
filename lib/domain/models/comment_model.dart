import 'package:desgram_ui/domain/models/partial_user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class CommentModel {
  final String id;
  final String content;
  final PartialUserModel user;
  final int amountLikes;
  final bool hasEdit;
  final bool hasLiked;

  CommentModel({
    required this.id,
    required this.content,
    required this.user,
    required this.amountLikes,
    required this.hasEdit,
    required this.hasLiked,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentModelToJson(this);
}
