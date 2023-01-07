// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partial_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartialUserModel _$PartialUserModelFromJson(Map<String, dynamic> json) =>
    PartialUserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] == null
          ? null
          : ImageWithUrlModel.fromJson(json['avatar'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PartialUserModelToJson(PartialUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatar': instance.avatar,
    };
