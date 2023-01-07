import 'package:json_annotation/json_annotation.dart';

import 'package:desgram_ui/domain/entities/db_entity.dart';

part 'interesting_post.g.dart';

@JsonSerializable()
class InterestingPost extends DbEntity<String> {
  final String postId;
  InterestingPost({
    required super.id,
    required this.postId,
  });

  factory InterestingPost.fromMap(Map<String, dynamic> map) =>
      _$InterestingPostFromJson(map);

  @override
  Map<String, dynamic> toMap() => _$InterestingPostToJson(this);
}
