// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_content_candidate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostContentCandidate _$PostContentCandidateFromJson(
        Map<String, dynamic> json) =>
    PostContentCandidate(
      id: json['id'] as String,
      width: json['width'] as int,
      height: json['height'] as int,
      url: json['url'] as String,
      mimeType: json['mimeType'] as String,
      postContentId: json['postContentId'] as String,
    );

Map<String, dynamic> _$PostContentCandidateToJson(
        PostContentCandidate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'width': instance.width,
      'height': instance.height,
      'url': instance.url,
      'mimeType': instance.mimeType,
      'postContentId': instance.postContentId,
    };
