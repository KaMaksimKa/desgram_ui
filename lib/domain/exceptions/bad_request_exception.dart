import 'package:json_annotation/json_annotation.dart';

part 'bad_request_exception.g.dart';

@JsonSerializable()
class BadRequestException implements Exception {
  final Map<String, List<String>> errors;
  BadRequestException({
    required this.errors,
  });

  factory BadRequestException.fromJson(Map<String, dynamic> json) =>
      _$BadRequestExceptionFromJson(json);
}
