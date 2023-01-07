import 'package:json_annotation/json_annotation.dart';

import 'package:desgram_ui/domain/models/user/partial_user_model.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class CommentModel {
  final String id;
  String content;
  final PartialUserModel user;
  int amountLikes;
  bool hasEdit;
  bool hasLiked;
  final DateTime createdDate;

  CommentModel({
    required this.id,
    required this.content,
    required this.user,
    required this.amountLikes,
    required this.hasEdit,
    required this.hasLiked,
    required this.createdDate,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentModelToJson(this);
}
