import 'package:json_annotation/json_annotation.dart';

import 'package:desgram_ui/domain/entities/db_entity.dart';

part 'user_post.g.dart';

@JsonSerializable()
class UserPost extends DbEntity<String> {
  final String userId;
  final String postId;
  UserPost({
    required super.id,
    required this.userId,
    required this.postId,
  });

  factory UserPost.fromMap(Map<String, dynamic> map) => _$UserPostFromJson(map);

  @override
  Map<String, dynamic> toMap() => _$UserPostToJson(this);
}
