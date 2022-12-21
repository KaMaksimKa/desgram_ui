import 'package:json_annotation/json_annotation.dart';

import 'package:desgram_ui/domain/entities/db_entity.dart';

part 'partial_user_avatar.g.dart';

@JsonSerializable()
class PartialUserAvatar extends DbEntity<String> {
  final int width;
  final int height;
  final String url;
  final String mimeType;
  final String partialUserId;

  PartialUserAvatar(
      {required super.id,
      required this.width,
      required this.height,
      required this.url,
      required this.mimeType,
      required this.partialUserId});

  factory PartialUserAvatar.fromMap(Map<String, dynamic> map) =>
      _$PartialUserAvatarFromJson(map);

  @override
  Map<String, dynamic> toMap() => _$PartialUserAvatarToJson(this);
}
