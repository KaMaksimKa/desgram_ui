import 'package:json_annotation/json_annotation.dart';

import 'package:desgram_ui/domain/entities/db_entity.dart';

part 'hashtag_post.g.dart';

@JsonSerializable()
class HashtagPost extends DbEntity<String> {
  final String hashtag;
  final String postId;
  HashtagPost({
    required super.id,
    required this.hashtag,
    required this.postId,
  });

  factory HashtagPost.fromMap(Map<String, dynamic> map) =>
      _$HashtagPostFromJson(map);

  @override
  Map<String, dynamic> toMap() => _$HashtagPostToJson(this);
}
