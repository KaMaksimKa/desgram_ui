import 'package:cached_network_image/cached_network_image.dart';
import 'package:desgram_ui/inrernal/dependencies/api_module.dart';
import 'package:desgram_ui/utils/helpers/image_content_helper.dart';
import 'package:flutter/material.dart';

import 'package:desgram_ui/domain/models/post_model.dart';

import '../../domain/models/image_content_model.dart';
import 'image_user_avatar.dart';

class PostFeedWidget extends StatefulWidget {
  final PostModel post;
  int currentImageIndex = 0;

  PostFeedWidget({
    super.key,
    required this.post,
  });

  @override
  State<PostFeedWidget> createState() => _PostFeedWidgetState();
}

class _PostFeedWidgetState extends State<PostFeedWidget> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              ImageUserAvatar(
                  imageContentModel: widget.post.user.avatar == null
                      ? null
                      : ImageContentModel(
                          imageCandidates: [widget.post.user.avatar!]),
                  size: 40),
              Container(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  widget.post.user.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 18),
                ),
              )
            ],
          ),
        ),
        SizedBox(
            height: size.width,
            child: PageView.builder(
                onPageChanged: (value) => setState(() {
                      widget.currentImageIndex = value;
                    }),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: CachedNetworkImageProvider(baseUrl +
                                ImageContentHelper.chooseImage(
                                        images: widget.post.imageContents[index]
                                            .imageCandidates,
                                        quality: ImageQuality.high)
                                    .url))),
                  );
                },
                itemCount: widget.post.imageContents.length)),
        Padding(
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: Column(
              children: [
                Stack(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      for (var i = 0; i < widget.post.imageContents.length; i++)
                        Padding(
                          padding: const EdgeInsets.all(1),
                          child: i == widget.currentImageIndex
                              ? const Icon(
                                  Icons.circle,
                                  size: 10,
                                  color: Colors.blue,
                                )
                              : const Icon(
                                  Icons.circle,
                                  size: 8,
                                  color: Color.fromARGB(255, 187, 187, 187),
                                ),
                        )
                    ]),
                    Row(children: [
                      const Icon(
                        Icons.favorite_border,
                        size: 32,
                      ),
                      if (widget.post.amountLikes != null)
                        Text(
                          widget.post.amountLikes.toString(),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      const SizedBox(width: 15),
                      const Icon(
                        Icons.insert_comment_outlined,
                        size: 32,
                      ),
                      if (widget.post.amountComments != null)
                        Text(
                          widget.post.amountComments.toString(),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                    ]),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      widget.post.user.name,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    Text(
                      widget.post.description,
                      style: TextStyle(fontSize: 17),
                    )
                  ],
                )
              ],
            )),
      ]),
    );
  }
}
