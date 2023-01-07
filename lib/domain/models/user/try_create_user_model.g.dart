// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'try_create_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TryCreateUserModel _$TryCreateUserModelFromJson(Map<String, dynamic> json) =>
    TryCreateUserModel(
      userName: json['userName'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      retryPassword: json['retryPassword'] as String,
    );

Map<String, dynamic> _$TryCreateUserModelToJson(TryCreateUserModel instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'email': instance.email,
      'password': instance.password,
      'retryPassword': instance.retryPassword,
    };
