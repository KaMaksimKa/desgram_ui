import 'package:json_annotation/json_annotation.dart';

part 'update_post_model.g.dart';

@JsonSerializable()
class UpdatePostModel {
  final String postId;
  final String description;

  UpdatePostModel({
    required this.postId,
    required this.description,
  });

  factory UpdatePostModel.fromJson(Map<String, dynamic> json) =>
      _$UpdatePostModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdatePostModelToJson(this);
}
