import 'package:json_annotation/json_annotation.dart';

import 'metadata_model.dart';

part 'create_post_model.g.dart';

@JsonSerializable()
class CreatePostModel {
  final String description;
  final List<MetadataModel> metadataModels;
  final bool isCommentsEnabled;
  final bool isLikesVisible;

  CreatePostModel({
    required this.description,
    required this.metadataModels,
    required this.isCommentsEnabled,
    required this.isLikesVisible,
  });

  factory CreatePostModel.fromJson(Map<String, dynamic> json) =>
      _$CreatePostModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePostModelToJson(this);
}
