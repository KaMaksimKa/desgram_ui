import 'package:flutter/material.dart';

import 'package:desgram_ui/domain/models/image_content_model.dart';
import '../../inrernal/dependencies/api_module.dart';

class ImageUserAvatar extends StatelessWidget {
  final ImageContentModel? imageContentModel;
  final double size;
  const ImageUserAvatar(
      {required this.imageContentModel, required this.size, super.key});

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
          backgroundImage: NetworkImage(_getUrlAvatar(imageContentModel)));
    }
  }

  static String _getUrlAvatar(ImageContentModel imageContentModel) {
    return "$baseUrl${imageContentModel.imageCandidates[0].url}";
  }
}
