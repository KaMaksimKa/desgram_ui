import 'package:json_annotation/json_annotation.dart';

import '../attach/image_with_url_model.dart';

part 'partial_post_model.g.dart';

@JsonSerializable()
class PartialPostModel {
  final String id;
  final ImageWithUrlModel previewImage;

  PartialPostModel({
    required this.id,
    required this.previewImage,
  });

  factory PartialPostModel.fromJson(Map<String, dynamic> json) =>
      _$PartialPostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PartialPostModelToJson(this);
}
