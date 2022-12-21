import 'package:json_annotation/json_annotation.dart';

import 'package:desgram_ui/domain/entities/db_entity.dart';

part 'post_content_candidate.g.dart';

@JsonSerializable()
class PostContentCandidate extends DbEntity<String> {
  final int width;
  final int height;
  final String url;
  final String mimeType;
  final String postContentId;

  PostContentCandidate(
      {required super.id,
      required this.width,
      required this.height,
      required this.url,
      required this.mimeType,
      required this.postContentId});

  factory PostContentCandidate.fromMap(Map<String, dynamic> map) =>
      _$PostContentCandidateFromJson(map);

  @override
  Map<String, dynamic> toMap() => _$PostContentCandidateToJson(this);
}
