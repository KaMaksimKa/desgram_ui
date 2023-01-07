import 'email_code_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'change_email_model.g.dart';

@JsonSerializable()
class ChangeEmailModel {
  final String newEmail;
  final EmailCodeModel emailCodeModel;

  ChangeEmailModel({
    required this.newEmail,
    required this.emailCodeModel,
  });

  factory ChangeEmailModel.fromJson(Map<String, dynamic> json) =>
      _$ChangeEmailModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChangeEmailModelToJson(this);
}
