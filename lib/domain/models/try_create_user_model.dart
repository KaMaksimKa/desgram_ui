import 'package:json_annotation/json_annotation.dart';

part 'try_create_user_model.g.dart';

@JsonSerializable()
class TryCreateUserModel {
  final String userName;
  final String email;
  final String password;
  final String retryPassword;

  TryCreateUserModel({
    required this.userName,
    required this.email,
    required this.password,
    required this.retryPassword,
  });

  factory TryCreateUserModel.fromJson(Map<String, dynamic> json) =>
      _$TryCreateUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$TryCreateUserModelToJson(this);
}
