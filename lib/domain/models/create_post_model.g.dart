// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePostModel _$CreatePostModelFromJson(Map<String, dynamic> json) =>
    CreatePostModel(
      description: json['description'] as String,
      metadataModels: (json['metadataModels'] as List<dynamic>)
          .map((e) => MetadataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isCommentsEnabled: json['isCommentsEnabled'] as bool,
      isLikesVisible: json['isLikesVisible'] as bool,
    );

Map<String, dynamic> _$CreatePostModelToJson(CreatePostModel instance) =>
    <String, dynamic>{
      'description': instance.description,
      'metadataModels': instance.metadataModels,
      'isCommentsEnabled': instance.isCommentsEnabled,
      'isLikesVisible': instance.isLikesVisible,
    };
