import 'package:desgram_ui/domain/models/attach/image_with_url_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'partial_user_model.g.dart';

@JsonSerializable()
class PartialUserModel {
  final String id;
  final String name;
  final ImageWithUrlModel? avatar;

  PartialUserModel({
    required this.id,
    required this.name,
    required this.avatar,
  });

  factory PartialUserModel.fromJson(Map<String, dynamic> json) =>
      _$PartialUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$PartialUserModelToJson(this);
}
