// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metadata_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetadataModel _$MetadataModelFromJson(Map<String, dynamic> json) =>
    MetadataModel(
      id: json['id'] as String,
      name: json['name'] as String,
      mimeType: json['mimeType'] as String,
    );

Map<String, dynamic> _$MetadataModelToJson(MetadataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'mimeType': instance.mimeType,
    };
