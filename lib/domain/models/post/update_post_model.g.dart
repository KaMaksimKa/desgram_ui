// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdatePostModel _$UpdatePostModelFromJson(Map<String, dynamic> json) =>
    UpdatePostModel(
      postId: json['postId'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$UpdatePostModelToJson(UpdatePostModel instance) =>
    <String, dynamic>{
      'postId': instance.postId,
      'description': instance.description,
    };
