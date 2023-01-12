import 'package:cached_network_image/cached_network_image.dart';
import 'package:desgram_ui/data/services/db_service.dart';
import 'package:desgram_ui/data/services/post_service.dart';
import 'package:desgram_ui/domain/exceptions/exceptions.dart';
import 'package:desgram_ui/ui/app_navigator.dart';
import 'package:desgram_ui/ui/common/no_network_dialog.dart';
import 'package:flutter/material.dart';

import 'package:desgram_ui/domain/models/post/post_model.dart';
import 'package:desgram_ui/inrernal/dependencies/api_module.dart';
import 'package:desgram_ui/ui/roots/main_page/main_page_navigator.dart';
import 'package:desgram_ui/utils/helpers/image_content_helper.dart';

import 'image_user_avatar.dart';

// ignore: must_be_immutable
class PostFeedWidget extends StatefulWidget {
  PostModel? post;
  final MainPageNavigator mainPageNavigator;
  final String currentUserId;

  PostFeedWidget(
      {Key? key,
      required this.post,
      required this.mainPageNavigator,
      required this.currentUserId})
      : super(key: key);

  @override
  State<PostFeedWidget> createState() => _PostFeedWidgetState();
}

class _PostFeedWidgetState extends State<PostFeedWidget> {
  final PostService _postService = PostService();
  int currentImageIndex = 0;
  @override
  void initState() {
    DbService.postsListeners.add(onPostUpdate);
    super.initState();
  }

  @override
  void dispose() {
    DbService.postsListeners.remove(onPostUpdate);
    super.dispose();
  }

  void onPostUpdate({required String postId, required PostModel? value}) {
    if (postId == widget.post?.id) {
      setState(() {
        widget.post = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var post = widget.post;
    var size = MediaQuery.of(context).size;
    return post == null
        ? Container()
        : Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          widget.mainPageNavigator
                              .toAnotherAccountContent(userId: post.user.id);
                        },
                        child: ImageUserAvatar.fromImageModel(
                            imageModel: post.user.avatar, size: 40),
                      ),
                    ),
                    Expanded(
                        flex: 5,
                        child: GestureDetector(
                          onTap: () {
                            widget.mainPageNavigator
                                .toAnotherAccountContent(userId: post.user.id);
                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              post.user.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                          ),
                        )),
                    Expanded(
                        child: widget.currentUserId == post.user.id
                            ? GestureDetector(
                                onTap: () => showMoreForPost(post: post),
                                child: const Icon(Icons.more_vert),
                              )
                            : Container())
                  ],
                ),
              ),
              SizedBox(
                  height: size.width,
                  child: GestureDetector(
                    onDoubleTap: () {
                      if (!post.hasLiked) {
                        _likePost();
                      }
                    },
                    child: PageView.builder(
                        onPageChanged: (value) => setState(() {
                              currentImageIndex = value;
                            }),
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: CachedNetworkImageProvider(baseUrl +
                                        ImageContentHelper.chooseImage(
                                                images: post
                                                    .imageContents[index]
                                                    .imageCandidates,
                                                quality: ImageQuality.high)
                                            .url))),
                          );
                        },
                        itemCount: post.imageContents.length),
                  )),
              Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (var i = 0;
                                    i < post.imageContents.length;
                                    i++)
                                  Padding(
                                    padding: const EdgeInsets.all(1),
                                    child: i == currentImageIndex
                                        ? const Icon(
                                            Icons.circle,
                                            size: 10,
                                            color: Colors.blue,
                                          )
                                        : const Icon(
                                            Icons.circle,
                                            size: 8,
                                            color: Color.fromARGB(
                                                255, 187, 187, 187),
                                          ),
                                  )
                              ]),
                          Row(children: [
                            post.hasLiked
                                ? GestureDetector(
                                    onTap: _unlikePost,
                                    child: const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                      size: 32,
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: _likePost,
                                    child: const Icon(
                                      Icons.favorite_border,
                                      size: 32,
                                    ),
                                  ),
                            if (post.amountLikes != null)
                              Text(
                                post.amountLikes.toString(),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            const SizedBox(width: 15),
                            if (post.isCommentsEnabled)
                              GestureDetector(
                                onTap: () {
                                  widget.mainPageNavigator
                                      .toComment(postModel: post);
                                },
                                child: const Icon(
                                  Icons.insert_comment_outlined,
                                  size: 32,
                                ),
                              ),
                            if (post.amountComments != null)
                              Text(
                                post.amountComments.toString(),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                          ]),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (post.description.isNotEmpty)
                        Row(
                          children: [
                            Text(
                              post.user.name,
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Text(
                              post.description,
                              style: const TextStyle(fontSize: 17),
                            )
                          ],
                        )
                    ],
                  )),
            ]),
          );
  }

  Future showMoreForPost({required PostModel post}) async {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: AppNavigator.key.currentState!.context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 4,
                width: 40,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 67, 67, 67),
                    borderRadius: BorderRadius.all(Radius.circular(4))),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(children: [
                  post.isLikesVisible
                      ? TextButton(
                          onPressed: () {
                            _changeLikesVisibilityPost(isLikesVisible: false);
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: const [
                                      Icon(
                                        Icons.favorite_outline,
                                        size: 30,
                                      ),
                                      Icon(
                                        Icons.close,
                                        size: 45,
                                      )
                                    ],
                                  )),
                              const Expanded(
                                  flex: 7,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      "Скрыть число отметок \"Нравиться\"",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ))
                            ],
                          ))
                      : TextButton(
                          onPressed: () {
                            _changeLikesVisibilityPost(isLikesVisible: true);
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black),
                          child: Row(
                            children: const [
                              Expanded(
                                  flex: 1,
                                  child: Icon(
                                    Icons.favorite_outline,
                                    size: 30,
                                  )),
                              Expanded(
                                  flex: 7,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      "Показать число отметок \"Нравиться\"",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ))
                            ],
                          )),
                  post.isCommentsEnabled
                      ? TextButton(
                          onPressed: () {
                            _changeIsCommentsEnabledPost(
                                isCommentsEnabled: false);
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: const [
                                      Icon(
                                        Icons.comment_outlined,
                                        size: 30,
                                      ),
                                      Icon(
                                        Icons.close,
                                        size: 45,
                                      )
                                    ],
                                  )),
                              const Expanded(
                                  flex: 7,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      "Выключить комментарии",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ))
                            ],
                          ))
                      : TextButton(
                          onPressed: () {
                            _changeIsCommentsEnabledPost(
                                isCommentsEnabled: true);
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black),
                          child: Row(
                            children: const [
                              Expanded(
                                  flex: 1,
                                  child: Icon(
                                    Icons.comment_outlined,
                                    size: 30,
                                  )),
                              Expanded(
                                  flex: 7,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      "Включить комментарии",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ))
                            ],
                          )),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        AppNavigator.toEditPostPage(postModel: post);
                      },
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black),
                      child: Row(
                        children: const [
                          Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.edit_outlined,
                                size: 30,
                              )),
                          Expanded(
                              flex: 7,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  "Редактировать",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                              ))
                        ],
                      )),
                  TextButton(
                      onPressed: () {
                        _deletePost();
                        Navigator.of(context).pop();
                      },
                      style:
                          TextButton.styleFrom(foregroundColor: Colors.black),
                      child: Row(
                        children: const [
                          Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                                size: 30,
                              )),
                          Expanded(
                              flex: 7,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  "Удалить",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                              ))
                        ],
                      ))
                ]),
              ),
              const SizedBox(
                height: 30,
              )
            ],
          );
        });
  }

  Future _likePost() async {
    var post = widget.post;
    if (post != null) {
      try {
        await _postService.likePost(postId: post.id);
      } on NoNetworkException {
        showNoNetworkDialog(context: context);
      }
    }
  }

  Future _unlikePost() async {
    var post = widget.post;
    if (post != null) {
      try {
        await _postService.unlikePost(postId: post.id);
      } on NoNetworkException {
        showNoNetworkDialog(context: context);
      }
    }
  }

  Future _changeIsCommentsEnabledPost({required bool isCommentsEnabled}) async {
    var post = widget.post;
    if (post != null) {
      try {
        await _postService.changeIsCommentsEnabledPost(
            postId: post.id, isCommentsEnabled: isCommentsEnabled);
      } on NoNetworkException {
        showNoNetworkDialog(context: context);
      }
    }
  }

  Future _changeLikesVisibilityPost({required bool isLikesVisible}) async {
    var post = widget.post;
    if (post != null) {
      try {
        await _postService.changeLikesVisibilityPost(
            postId: post.id, isLikesVisible: isLikesVisible);
      } on NoNetworkException {
        showNoNetworkDialog(context: context);
      }
    }
  }

  Future _deletePost() async {
    var post = widget.post;
    if (post != null) {
      try {
        await _postService.deletePost(postId: post.id);
      } on NoNetworkException {
        showNoNetworkDialog(context: context);
      }
    }
  }
}
