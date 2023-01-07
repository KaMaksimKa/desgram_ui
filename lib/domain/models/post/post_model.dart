import 'package:json_annotation/json_annotation.dart';

import 'package:desgram_ui/domain/models/attach/image_content_model.dart';
import 'package:desgram_ui/domain/models/user/partial_user_model.dart';

part 'post_model.g.dart';

@JsonSerializable()
class PostModel {
  final String id;
  final PartialUserModel user;
  final String description;
  final int? amountLikes;
  final int? amountComments;
  final bool isCommentsEnabled;
  final bool isLikesVisible;
  final bool hasLiked;
  final bool hasEdit;
  final DateTime createdDate;
  final List<ImageContentModel> imageContents;

  PostModel({
    required this.id,
    required this.user,
    required this.description,
    required this.amountLikes,
    required this.amountComments,
    required this.isCommentsEnabled,
    required this.isLikesVisible,
    required this.hasLiked,
    required this.hasEdit,
    required this.createdDate,
    required this.imageContents,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);
}
