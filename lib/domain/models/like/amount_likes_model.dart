import 'package:json_annotation/json_annotation.dart';

part 'amount_likes_model.g.dart';

@JsonSerializable()
class AmountLikesModel {
  final int? amountLikes;

  AmountLikesModel({
    required this.amountLikes,
  });

  factory AmountLikesModel.fromJson(Map<String, dynamic> json) =>
      _$AmountLikesModelFromJson(json);

  Map<String, dynamic> toJson() => _$AmountLikesModelToJson(this);
}
