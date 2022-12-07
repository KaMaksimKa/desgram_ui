// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      fullName: json['fullName'] as String,
      biography: json['biography'] as String,
      avatar: json['avatar'] == null
          ? null
          : ImageContentModel.fromJson(json['avatar'] as Map<String, dynamic>),
      amountFollowing: json['amountFollowing'] as int,
      amountFollowers: json['amountFollowers'] as int,
      amountPosts: json['amountPosts'] as int,
      isPrivate: json['isPrivate'] as bool,
      followedByViewer: json['followedByViewer'] as bool,
      hasRequestedViewer: json['hasRequestedViewer'] as bool,
      followsViewer: json['followsViewer'] as bool,
      hasBlockedViewer: json['hasBlockedViewer'] as bool,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'fullName': instance.fullName,
      'biography': instance.biography,
      'avatar': instance.avatar,
      'amountFollowing': instance.amountFollowing,
      'amountFollowers': instance.amountFollowers,
      'amountPosts': instance.amountPosts,
      'isPrivate': instance.isPrivate,
      'followedByViewer': instance.followedByViewer,
      'hasRequestedViewer': instance.hasRequestedViewer,
      'followsViewer': instance.followsViewer,
      'hasBlockedViewer': instance.hasBlockedViewer,
    };
