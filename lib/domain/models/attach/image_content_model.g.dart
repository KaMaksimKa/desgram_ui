// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_content_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageContentModel _$ImageContentModelFromJson(Map<String, dynamic> json) =>
    ImageContentModel(
      imageCandidates: (json['imageCandidates'] as List<dynamic>)
          .map((e) => ImageWithUrlModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ImageContentModelToJson(ImageContentModel instance) =>
    <String, dynamic>{
      'imageCandidates': instance.imageCandidates,
    };
