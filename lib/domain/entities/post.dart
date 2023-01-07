import 'package:json_annotation/json_annotation.dart';

import 'package:desgram_ui/domain/entities/db_entity.dart';

part 'post.g.dart';

@JsonSerializable()
class Post extends DbEntity<String> {
  final String userId;
  final String description;
  final int? amountLikes;
  final int? amountComments;
  final int isCommentsEnabled;
  final int isLikesVisible;
  final int hasLiked;
  final int hasEdit;
  final DateTime createdDate;
  Post({
    required super.id,
    required this.userId,
    required this.description,
    required this.amountLikes,
    required this.amountComments,
    required this.isCommentsEnabled,
    required this.isLikesVisible,
    required this.hasLiked,
    required this.hasEdit,
    required this.createdDate,
  });

  factory Post.fromMap(Map<String, dynamic> map) => _$PostFromJson(map);

  @override
  Map<String, dynamic> toMap() => _$PostToJson(this);
}
