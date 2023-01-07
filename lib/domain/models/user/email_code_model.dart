import 'package:json_annotation/json_annotation.dart';

part 'email_code_model.g.dart';

@JsonSerializable()
class EmailCodeModel {
  final String id;
  final String code;

  EmailCodeModel({
    required this.id,
    required this.code,
  });

  factory EmailCodeModel.fromJson(Map<String, dynamic> json) =>
      _$EmailCodeModelFromJson(json);

  Map<String, dynamic> toJson() => _$EmailCodeModelToJson(this);
}
