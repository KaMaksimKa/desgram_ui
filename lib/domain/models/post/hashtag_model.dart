import 'package:json_annotation/json_annotation.dart';

part 'hashtag_model.g.dart';

@JsonSerializable()
class HashtagModel {
  final String hashtag;
  final int amountPosts;
  HashtagModel({
    required this.hashtag,
    required this.amountPosts,
  });

  factory HashtagModel.fromJson(Map<String, dynamic> json) =>
      _$HashtagModelFromJson(json);

  Map<String, dynamic> toJson() => _$HashtagModelToJson(this);
}
