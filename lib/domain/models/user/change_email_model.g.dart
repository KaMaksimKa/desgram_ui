// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_email_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangeEmailModel _$ChangeEmailModelFromJson(Map<String, dynamic> json) =>
    ChangeEmailModel(
      newEmail: json['newEmail'] as String,
      emailCodeModel: EmailCodeModel.fromJson(
          json['emailCodeModel'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChangeEmailModelToJson(ChangeEmailModel instance) =>
    <String, dynamic>{
      'newEmail': instance.newEmail,
      'emailCodeModel': instance.emailCodeModel,
    };
