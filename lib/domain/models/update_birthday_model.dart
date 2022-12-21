import 'package:json_annotation/json_annotation.dart';

part 'update_birthday_model.g.dart';

@JsonSerializable()
class UpdateBirthdayModel {
  final DateTime? birthday;

  UpdateBirthdayModel({
    required this.birthday,
  });

  factory UpdateBirthdayModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateBirthdayModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateBirthdayModelToJson(this);
}
