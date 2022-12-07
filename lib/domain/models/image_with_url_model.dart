import 'attach_with_url_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'image_with_url_model.g.dart';

@JsonSerializable()
class ImageWithUrlModel extends AttachWithUrlModel {
  int width;
  int height;
  ImageWithUrlModel({
    required super.id,
    required super.url,
    required super.mimeType,
    required this.width,
    required this.height,
  });

  factory ImageWithUrlModel.fromJson(Map<String, dynamic> json) =>
      _$ImageWithUrlModelFromJson(json);

  Map<String, dynamic> toJson() => _$ImageWithUrlModelToJson(this);
}
