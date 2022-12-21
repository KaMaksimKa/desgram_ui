// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) => PostModel(
      id: json['id'] as String,
      user: PartialUserModel.fromJson(json['user'] as Map<String, dynamic>),
      description: json['description'] as String,
      amountLikes: json['amountLikes'] as int?,
      amountComments: json['amountComments'] as int?,
      isCommentsEnabled: json['isCommentsEnabled'] as bool,
      createdDate: DateTime.parse(json['createdDate'] as String),
      imageContents: (json['imageContents'] as List<dynamic>)
          .map((e) => ImageContentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasLiked: json['hasLiked'] as bool,
    );

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'description': instance.description,
      'amountLikes': instance.amountLikes,
      'amountComments': instance.amountComments,
      'isCommentsEnabled': instance.isCommentsEnabled,
      'hasLiked': instance.hasLiked,
      'createdDate': instance.createdDate.toIso8601String(),
      'imageContents': instance.imageContents,
    };
