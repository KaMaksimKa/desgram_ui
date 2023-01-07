import 'package:json_annotation/json_annotation.dart';

part 'change_user_name_model.g.dart';

@JsonSerializable()
class ChangeUserNameModel {
  final String? newName;

  ChangeUserNameModel({
    required this.newName,
  });

  factory ChangeUserNameModel.fromJson(Map<String, dynamic> json) =>
      _$ChangeUserNameModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChangeUserNameModelToJson(this);
}
