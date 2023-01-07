import 'package:desgram_ui/domain/models/user/try_create_user_model.dart';

import 'email_code_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_user_model.g.dart';

@JsonSerializable()
class CreateUserModel {
  final TryCreateUserModel tryCreateUserModel;
  final EmailCodeModel emailCodeModel;

  CreateUserModel({
    required this.tryCreateUserModel,
    required this.emailCodeModel,
  });

  factory CreateUserModel.fromJson(Map<String, dynamic> json) =>
      _$CreateUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateUserModelToJson(this);
}
