// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bad_request_exception.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BadRequestException _$BadRequestExceptionFromJson(Map<String, dynamic> json) =>
    BadRequestException(
      errors: (json['errors'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
      ),
    );

Map<String, dynamic> _$BadRequestExceptionToJson(
        BadRequestException instance) =>
    <String, dynamic>{
      'errors': instance.errors,
    };
