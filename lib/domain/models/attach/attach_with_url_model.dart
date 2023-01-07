import 'package:json_annotation/json_annotation.dart';

part 'attach_with_url_model.g.dart';

@JsonSerializable()
class AttachWithUrlModel {
  final String id;
  final String url;
  final String mimeType;

  AttachWithUrlModel({
    required this.id,
    required this.url,
    required this.mimeType,
  });

  factory AttachWithUrlModel.fromJson(Map<String, dynamic> json) =>
      _$AttachWithUrlModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttachWithUrlModelToJson(this);
}
