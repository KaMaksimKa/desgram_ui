import 'package:cached_network_image/cached_network_image.dart';
import 'package:desgram_ui/domain/models/attach/image_with_url_model.dart';
import 'package:flutter/material.dart';

import 'package:desgram_ui/domain/models/attach/image_content_model.dart';
import '../../inrernal/dependencies/api_module.dart';

class ImageUserAvatar extends StatelessWidget {
  final ImageContentModel? imageContentModel;
  final double size;
  const ImageUserAvatar(
      {required this.imageContentModel, required this.size, super.key});

  factory ImageUserAvatar.fromImageModel(
      {required ImageWithUrlModel? imageModel, required double size}) {
    return ImageUserAvatar(
        imageContentModel: imageModel == null
            ? null
            : ImageContentModel(imageCandidates: [imageModel]),
        size: size);
  }

  @override
  Widget build(BuildContext context) {
    var imageContentModel = this.imageContentModel;
    if (imageContentModel == null) {
      return Icon(
        Icons.account_circle,
        color: Colors.grey,
        size: size,
      );
    } else {
      return CircleAvatar(
          radius: size / 2,
          backgroundImage:
              CachedNetworkImageProvider(_getUrlAvatar(imageContentModel)));
    }
  }

  static String _getUrlAvatar(ImageContentModel imageContentModel) {
    return "$baseUrl${imageContentModel.imageCandidates[0].url}";
  }
}
