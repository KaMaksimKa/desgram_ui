import 'package:desgram_ui/domain/entities/db_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post extends DbEntity<String> {
  final String userId;
  final String description;
  final int? amountLikes;
  final int? amountComments;
  final int isCommentsEnabled;
  final int hasLiked;
  final DateTime createdDate;
  Post({
    required super.id,
    required this.userId,
    required this.description,
    required this.amountLikes,
    required this.amountComments,
    required this.isCommentsEnabled,
    required this.hasLiked,
    required this.createdDate,
  });

  factory Post.fromMap(Map<String, dynamic> map) => _$PostFromJson(map);

  @override
  Map<String, dynamic> toMap() => _$PostToJson(this);
}
