import 'package:json_annotation/json_annotation.dart';

part 'personal_information_model.g.dart';

@JsonSerializable()
class PersonalInformationModel {
  final String email;
  final DateTime birthDate;

  PersonalInformationModel({
    required this.email,
    required this.birthDate,
  });

  factory PersonalInformationModel.fromJson(Map<String, dynamic> json) =>
      _$PersonalInformationModelFromJson(json);

  Map<String, dynamic> toJson() => _$PersonalInformationModelToJson(this);
}
