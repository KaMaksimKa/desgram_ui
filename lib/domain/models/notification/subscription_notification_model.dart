import 'package:json_annotation/json_annotation.dart';

import 'package:desgram_ui/domain/models/user/partial_user_model.dart';

part 'subscription_notification_model.g.dart';

@JsonSerializable()
class SubscriptionNotificationModel {
  final PartialUserModel user;
  final bool isApproved;

  SubscriptionNotificationModel({
    required this.user,
    required this.isApproved,
  });

  factory SubscriptionNotificationModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionNotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionNotificationModelToJson(this);
}
