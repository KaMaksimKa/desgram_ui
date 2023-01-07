import 'package:json_annotation/json_annotation.dart';

import 'package:desgram_ui/domain/entities/db_entity.dart';

part 'search_string.g.dart';

@JsonSerializable()
class SearchString extends DbEntity<String> {
  final String searchString;
  SearchString({
    required super.id,
    required this.searchString,
  });

  factory SearchString.fromMap(Map<String, dynamic> map) =>
      _$SearchStringFromJson(map);

  @override
  Map<String, dynamic> toMap() => _$SearchStringToJson(this);
}
