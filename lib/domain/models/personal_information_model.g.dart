// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_information_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalInformationModel _$PersonalInformationModelFromJson(
        Map<String, dynamic> json) =>
    PersonalInformationModel(
      email: json['email'] as String,
      birthDate: DateTime.parse(json['birthDate'] as String),
    );

Map<String, dynamic> _$PersonalInformationModelToJson(
        PersonalInformationModel instance) =>
    <String, dynamic>{
      'email': instance.email,
      'birthDate': instance.birthDate.toIso8601String(),
    };
