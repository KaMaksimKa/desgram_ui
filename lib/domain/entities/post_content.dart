import 'package:desgram_ui/domain/entities/db_entity.dart';

import 'package:json_annotation/json_annotation.dart';

part 'post_content.g.dart';

@JsonSerializable()
class PostContent extends DbEntity<String> {
  final String postId;

  PostContent({
    required super.id,
    required this.postId,
  });

  factory PostContent.fromMap(Map<String, dynamic> map) =>
      _$PostContentFromJson(map);

  @override
  Map<String, dynamic> toMap() => _$PostContentToJson(this);
}
