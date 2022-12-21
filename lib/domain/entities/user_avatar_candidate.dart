import 'package:json_annotation/json_annotation.dart';

import 'package:desgram_ui/domain/entities/db_entity.dart';

part 'user_avatar_candidate.g.dart';

@JsonSerializable()
class UserAvatarCandidate extends DbEntity<String> {
  final int width;
  final int height;
  final String url;
  final String mimeType;
  final String userAvatarId;

  UserAvatarCandidate(
      {required super.id,
      required this.width,
      required this.height,
      required this.url,
      required this.mimeType,
      required this.userAvatarId});

  factory UserAvatarCandidate.fromMap(Map<String, dynamic> map) =>
      _$UserAvatarCandidateFromJson(map);

  @override
  Map<String, dynamic> toMap() => _$UserAvatarCandidateToJson(this);
}
