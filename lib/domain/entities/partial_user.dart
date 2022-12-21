import 'package:desgram_ui/domain/entities/db_entity.dart';

import 'package:json_annotation/json_annotation.dart';

part 'partial_user.g.dart';

@JsonSerializable()
class PartialUser extends DbEntity<String> {
  final String name;

  PartialUser({
    required super.id,
    required this.name,
  });

  factory PartialUser.fromMap(Map<String, dynamic> map) =>
      _$PartialUserFromJson(map);

  @override
  Map<String, dynamic> toMap() => _$PartialUserToJson(this);
}
