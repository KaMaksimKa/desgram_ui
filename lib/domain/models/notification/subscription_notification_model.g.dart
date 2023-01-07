// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionNotificationModel _$SubscriptionNotificationModelFromJson(
        Map<String, dynamic> json) =>
    SubscriptionNotificationModel(
      user: PartialUserModel.fromJson(json['user'] as Map<String, dynamic>),
      isApproved: json['isApproved'] as bool,
    );

Map<String, dynamic> _$SubscriptionNotificationModelToJson(
        SubscriptionNotificationModel instance) =>
    <String, dynamic>{
      'user': instance.user,
      'isApproved': instance.isApproved,
    };
