// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hashtag_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HashtagModel _$HashtagModelFromJson(Map<String, dynamic> json) => HashtagModel(
      hashtag: json['hashtag'] as String,
      amountPosts: json['amountPosts'] as int,
    );

Map<String, dynamic> _$HashtagModelToJson(HashtagModel instance) =>
    <String, dynamic>{
      'hashtag': instance.hashtag,
      'amountPosts': instance.amountPosts,
    };
