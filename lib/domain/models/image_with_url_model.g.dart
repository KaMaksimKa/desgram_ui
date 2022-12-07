// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_with_url_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageWithUrlModel _$ImageWithUrlModelFromJson(Map<String, dynamic> json) =>
    ImageWithUrlModel(
      id: json['id'] as String,
      url: json['url'] as String,
      mimeType: json['mimeType'] as String,
      width: json['width'] as int,
      height: json['height'] as int,
    );

Map<String, dynamic> _$ImageWithUrlModelToJson(ImageWithUrlModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'mimeType': instance.mimeType,
      'width': instance.width,
      'height': instance.height,
    };
