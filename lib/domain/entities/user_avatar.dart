import 'package:desgram_ui/domain/entities/db_entity.dart';

import 'package:json_annotation/json_annotation.dart';

part 'user_avatar.g.dart';

@JsonSerializable()
class UserAvatar extends DbEntity<String> {
  final String userId;

  UserAvatar({
    required super.id,
    required this.userId,
  });

  factory UserAvatar.fromMap(Map<String, dynamic> map) =>
      _$UserAvatarFromJson(map);

  @override
  Map<String, dynamic> toMap() => _$UserAvatarToJson(this);
}
