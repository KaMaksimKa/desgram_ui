// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partial_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartialPostModel _$PartialPostModelFromJson(Map<String, dynamic> json) =>
    PartialPostModel(
      id: json['id'] as String,
      previewImage: ImageWithUrlModel.fromJson(
          json['previewImage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PartialPostModelToJson(PartialPostModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'previewImage': instance.previewImage,
    };
