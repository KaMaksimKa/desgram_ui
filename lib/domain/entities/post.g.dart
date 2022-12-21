// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      id: json['id'] as String,
      userId: json['userId'] as String,
      description: json['description'] as String,
      amountLikes: json['amountLikes'] as int?,
      amountComments: json['amountComments'] as int?,
      isCommentsEnabled: json['isCommentsEnabled'] as int,
      hasLiked: json['hasLiked'] as int,
      createdDate: DateTime.parse(json['createdDate'] as String),
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'description': instance.description,
      'amountLikes': instance.amountLikes,
      'amountComments': instance.amountComments,
      'isCommentsEnabled': instance.isCommentsEnabled,
      'hasLiked': instance.hasLiked,
      'createdDate': instance.createdDate.toIso8601String(),
    };
