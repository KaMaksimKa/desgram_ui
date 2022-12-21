// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateCommentModel _$UpdateCommentModelFromJson(Map<String, dynamic> json) =>
    UpdateCommentModel(
      commentId: json['commentId'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$UpdateCommentModelToJson(UpdateCommentModel instance) =>
    <String, dynamic>{
      'commentId': instance.commentId,
      'content': instance.content,
    };
