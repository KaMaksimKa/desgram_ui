import 'package:cached_network_image/cached_network_image.dart';
import 'package:desgram_ui/domain/models/post/post_model.dart';
import 'package:flutter/material.dart';

import '../../inrernal/dependencies/api_module.dart';
import '../../utils/helpers/image_content_helper.dart';

class PostOnGridWidget extends StatelessWidget {
  final PostModel post;
  const PostOnGridWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: CachedNetworkImageProvider(baseUrl +
                  ImageContentHelper.chooseImage(
                          images: post.imageContents[0].imageCandidates,
                          quality: ImageQuality.low)
                      .url))),
    );
  }
}
