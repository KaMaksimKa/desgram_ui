// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_birthday_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateBirthdayModel _$UpdateBirthdayModelFromJson(Map<String, dynamic> json) =>
    UpdateBirthdayModel(
      birthday: json['birthday'] == null
          ? null
          : DateTime.parse(json['birthday'] as String),
    );

Map<String, dynamic> _$UpdateBirthdayModelToJson(
        UpdateBirthdayModel instance) =>
    <String, dynamic>{
      'birthday': instance.birthday?.toIso8601String(),
    };
