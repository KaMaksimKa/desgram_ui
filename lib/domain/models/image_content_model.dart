import 'package:desgram_ui/domain/models/image_with_url_model.dart';

import 'package:json_annotation/json_annotation.dart';

part 'image_content_model.g.dart';

@JsonSerializable()
class ImageContentModel {
  final List<ImageWithUrlModel> imageCandidates;
  ImageContentModel({
    required this.imageCandidates,
  });

  factory ImageContentModel.fromJson(Map<String, dynamic> json) =>
      _$ImageContentModelFromJson(json);

  Map<String, dynamic> toJson() => _$ImageContentModelToJson(this);
}
