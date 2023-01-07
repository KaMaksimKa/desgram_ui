// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateUserModel _$CreateUserModelFromJson(Map<String, dynamic> json) =>
    CreateUserModel(
      tryCreateUserModel: TryCreateUserModel.fromJson(
          json['tryCreateUserModel'] as Map<String, dynamic>),
      emailCodeModel: EmailCodeModel.fromJson(
          json['emailCodeModel'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateUserModelToJson(CreateUserModel instance) =>
    <String, dynamic>{
      'tryCreateUserModel': instance.tryCreateUserModel,
      'emailCodeModel': instance.emailCodeModel,
    };
