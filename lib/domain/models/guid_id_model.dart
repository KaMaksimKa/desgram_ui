import 'package:json_annotation/json_annotation.dart';

part 'guid_id_model.g.dart';

@JsonSerializable()
class GuidIdModel {
  final String id;

  GuidIdModel({
    required this.id,
  });

  factory GuidIdModel.fromJson(Map<String, dynamic> json) =>
      _$GuidIdModelFromJson(json);

  Map<String, dynamic> toJson() => _$GuidIdModelToJson(this);
}
