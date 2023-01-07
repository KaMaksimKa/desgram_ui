import 'package:cached_network_image/cached_network_image.dart';
import 'package:desgram_ui/domain/models/notification/notification_model.dart';
import 'package:desgram_ui/inrernal/dependencies/api_module.dart';
import 'package:desgram_ui/ui/app_widgets/image_user_avatar.dart';
import 'package:desgram_ui/ui/roots/main_page/main_page_navigator.dart';
import 'package:flutter/material.dart';

class NotificationRowWidget extends StatelessWidget {
  final NotificationModel notificationModel;
  final MainPageNavigator mainPageNavigator;
  final Function() deleteSubRequest;
  final Function() acceptSubRequest;
  const NotificationRowWidget(
      {super.key,
      required this.notificationModel,
      required this.mainPageNavigator,
      required this.deleteSubRequest,
      required this.acceptSubRequest});

  @override
  Widget build(BuildContext context) {
    var likePost = notificationModel.likePost;
    var likeComment = notificationModel.likeComment;
    var comment = notificationModel.comment;
    var subscription = notificationModel.subscription;

    if (likePost != null) {
      return Row(
        children: [
          if (!notificationModel.hasViewed)
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Container(
                height: 10,
                width: 10,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.red),
              ),
            ),
          Expanded(
              child: GestureDetector(
            onTap: () {
              mainPageNavigator.toAnotherAccountContent(
                  userId: likePost.user.id);
            },
            child: ImageUserAvatar.fromImageModel(
                imageModel: likePost.user.avatar, size: 45),
          )),
          Expanded(
            flex: 3,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      mainPageNavigator.toAnotherAccountContent(
                          userId: likePost.user.id);
                    },
                    child: Text(
                      likePost.user.name,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Text(
                    "нравится ваша публикация",
                    style: TextStyle(fontSize: 17),
                  ),
                ]),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          baseUrl + likePost.post.previewImage.url))),
            ),
          )
        ],
      );
    } else if (likeComment != null) {
      return Row(
        children: [
          if (!notificationModel.hasViewed)
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Container(
                height: 10,
                width: 10,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.red),
              ),
            ),
          Expanded(
              child: GestureDetector(
            onTap: () {
              mainPageNavigator.toAnotherAccountContent(
                  userId: likeComment.user.id);
            },
            child: ImageUserAvatar.fromImageModel(
                imageModel: likeComment.user.avatar, size: 45),
          )),
          Expanded(
            flex: 3,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      mainPageNavigator.toAnotherAccountContent(
                          userId: likeComment.user.id);
                    },
                    child: Text(
                      likeComment.user.name,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    "нравится ваш комментарий: ${likeComment.comment}",
                    style: const TextStyle(fontSize: 17),
                  ),
                ]),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          baseUrl + likeComment.post.previewImage.url))),
            ),
          )
        ],
      );
    } else if (comment != null) {
      return Row(
        children: [
          if (!notificationModel.hasViewed)
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Container(
                height: 10,
                width: 10,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.red),
              ),
            ),
          Expanded(
              child: GestureDetector(
            onTap: () {
              mainPageNavigator.toAnotherAccountContent(
                  userId: comment.user.id);
            },
            child: ImageUserAvatar.fromImageModel(
                imageModel: comment.user.avatar, size: 45),
          )),
          Expanded(
            flex: 3,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      mainPageNavigator.toAnotherAccountContent(
                          userId: comment.user.id);
                    },
                    child: Text(
                      comment.user.name,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    "прокомментировал(-а): ${comment.content}",
                    style: const TextStyle(fontSize: 17),
                  ),
                ]),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          baseUrl + comment.post.previewImage.url))),
            ),
          )
        ],
      );
    } else if (subscription != null) {
      if (subscription.isApproved) {
        return Row(
          children: [
            if (!notificationModel.hasViewed)
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.red),
                ),
              ),
            Expanded(
                child: GestureDetector(
              onTap: () {
                mainPageNavigator.toAnotherAccountContent(
                    userId: subscription.user.id);
              },
              child: ImageUserAvatar.fromImageModel(
                  imageModel: subscription.user.avatar, size: 45),
            )),
            Expanded(
              flex: 4,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        mainPageNavigator.toAnotherAccountContent(
                            userId: subscription.user.id);
                      },
                      child: Text(
                        subscription.user.name,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Text(
                      "подписался(-ась) на ваши обновления.",
                      style: TextStyle(fontSize: 17),
                    ),
                  ]),
            ),
          ],
        );
      } else {
        return Row(
          children: [
            if (!notificationModel.hasViewed)
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.red),
                ),
              ),
            Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () {
                    mainPageNavigator.toAnotherAccountContent(
                        userId: subscription.user.id);
                  },
                  child: ImageUserAvatar.fromImageModel(
                      imageModel: subscription.user.avatar, size: 45),
                )),
            Expanded(
              flex: 4,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        mainPageNavigator.toAnotherAccountContent(
                            userId: subscription.user.id);
                      },
                      child: Text(
                        subscription.user.name,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Text(
                      "хочет подписаться на вас.",
                      style: TextStyle(fontSize: 17),
                    ),
                  ]),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(8),
                    ),
                    onPressed: acceptSubRequest,
                    child: const Text("Подтвердить",
                        overflow: TextOverflow.ellipsis),
                  )),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: ElevatedButton(
                    onPressed: deleteSubRequest,
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(8),
                        foregroundColor: Colors.black,
                        backgroundColor:
                            const Color.fromARGB(255, 205, 205, 205)),
                    child:
                        const Text("Удалить", overflow: TextOverflow.ellipsis),
                  )),
            )
          ],
        );
      }
    }
    return Row();
  }
}
