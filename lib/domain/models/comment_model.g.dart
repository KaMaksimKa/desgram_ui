// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) => CommentModel(
      id: json['id'] as String,
      content: json['content'] as String,
      user: PartialUserModel.fromJson(json['user'] as Map<String, dynamic>),
      amountLikes: json['amountLikes'] as int,
      hasEdit: json['hasEdit'] as bool,
      hasLiked: json['hasLiked'] as bool,
    );

Map<String, dynamic> _$CommentModelToJson(CommentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'user': instance.user,
      'amountLikes': instance.amountLikes,
      'hasEdit': instance.hasEdit,
      'hasLiked': instance.hasLiked,
    };
