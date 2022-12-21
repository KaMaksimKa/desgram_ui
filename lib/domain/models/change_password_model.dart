import 'package:json_annotation/json_annotation.dart';

part 'change_password_model.g.dart';

@JsonSerializable()
class ChangePasswordModel {
  final String oldPassword;
  final String newPassword;
  final String retryNewPassword;

  ChangePasswordModel({
    required this.oldPassword,
    required this.newPassword,
    required this.retryNewPassword,
  });

  factory ChangePasswordModel.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePasswordModelToJson(this);
}
