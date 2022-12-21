import 'package:json_annotation/json_annotation.dart';

part 'change_likes_visibility_model.g.dart';

@JsonSerializable()
class ChangeLikesVisibilityModel {
  final String postId;
  final bool isLikesVisible;

  ChangeLikesVisibilityModel({
    required this.postId,
    required this.isLikesVisible,
  });

  factory ChangeLikesVisibilityModel.fromJson(Map<String, dynamic> json) =>
      _$ChangeLikesVisibilityModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChangeLikesVisibilityModelToJson(this);
}
