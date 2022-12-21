import 'package:desgram_ui/domain/entities/db_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends DbEntity<String> {
  final String name;
  final String fullName;
  final String biography;
  final int amountFollowing;
  final int amountFollowers;
  final int amountPosts;
  final int isPrivate;
  final int followedByViewer;
  final int hasRequestedViewer;
  final int followsViewer;
  final int hasBlockedViewer;

  User({
    required super.id,
    required this.name,
    required this.fullName,
    required this.biography,
    required this.amountFollowing,
    required this.amountFollowers,
    required this.amountPosts,
    required this.isPrivate,
    required this.followedByViewer,
    required this.hasRequestedViewer,
    required this.followsViewer,
    required this.hasBlockedViewer,
  });

  factory User.fromMap(Map<String, dynamic> map) => _$UserFromJson(map);

  @override
  Map<String, dynamic> toMap() => _$UserToJson(this);
}
