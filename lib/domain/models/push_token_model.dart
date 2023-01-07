import 'package:json_annotation/json_annotation.dart';

part 'push_token_model.g.dart';

@JsonSerializable()
class PushTokenModel {
  final String token;

  PushTokenModel({
    required this.token,
  });

  factory PushTokenModel.fromJson(Map<String, dynamic> json) =>
      _$PushTokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$PushTokenModelToJson(this);
}
