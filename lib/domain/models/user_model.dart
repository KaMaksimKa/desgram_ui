import 'package:desgram_ui/domain/models/image_content_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String name;
  final String fullName;
  final String biography;
  final ImageContentModel? avatar;
  final int amountFollowing;
  final int amountFollowers;
  final int amountPosts;
  final bool isPrivate;
  final bool followedByViewer;
  final bool hasRequestedViewer;
  final bool followsViewer;
  final bool hasBlockedViewer;

  UserModel({
    required this.id,
    required this.name,
    required this.fullName,
    required this.biography,
    this.avatar,
    required this.amountFollowing,
    required this.amountFollowers,
    required this.amountPosts,
    required this.isPrivate,
    required this.followedByViewer,
    required this.hasRequestedViewer,
    required this.followsViewer,
    required this.hasBlockedViewer,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
