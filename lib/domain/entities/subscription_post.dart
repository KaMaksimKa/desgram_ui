import 'package:json_annotation/json_annotation.dart';

import 'package:desgram_ui/domain/entities/db_entity.dart';

part 'subscription_post.g.dart';

@JsonSerializable()
class SubscriptionPost extends DbEntity<String> {
  final String postId;
  SubscriptionPost({
    required super.id,
    required this.postId,
  });

  factory SubscriptionPost.fromMap(Map<String, dynamic> map) =>
      _$SubscriptionPostFromJson(map);

  @override
  Map<String, dynamic> toMap() => _$SubscriptionPostToJson(this);
}
