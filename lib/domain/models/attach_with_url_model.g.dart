// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attach_with_url_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttachWithUrlModel _$AttachWithUrlModelFromJson(Map<String, dynamic> json) =>
    AttachWithUrlModel(
      id: json['id'] as String,
      url: json['url'] as String,
      mimeType: json['mimeType'] as String,
    );

Map<String, dynamic> _$AttachWithUrlModelToJson(AttachWithUrlModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'mimeType': instance.mimeType,
    };
