// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      name: json['name'] as String,
      fullName: json['fullName'] as String,
      biography: json['biography'] as String,
      amountFollowing: json['amountFollowing'] as int,
      amountFollowers: json['amountFollowers'] as int,
      amountPosts: json['amountPosts'] as int,
      isPrivate: json['isPrivate'] as int,
      followedByViewer: json['followedByViewer'] as int,
      hasRequestedViewer: json['hasRequestedViewer'] as int,
      followsViewer: json['followsViewer'] as int,
      hasBlockedViewer: json['hasBlockedViewer'] as int,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'fullName': instance.fullName,
      'biography': instance.biography,
      'amountFollowing': instance.amountFollowing,
      'amountFollowers': instance.amountFollowers,
      'amountPosts': instance.amountPosts,
      'isPrivate': instance.isPrivate,
      'followedByViewer': instance.followedByViewer,
      'hasRequestedViewer': instance.hasRequestedViewer,
      'followsViewer': instance.followsViewer,
      'hasBlockedViewer': instance.hasBlockedViewer,
    };
