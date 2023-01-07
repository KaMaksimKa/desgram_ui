import 'package:desgram_ui/domain/models/attach/image_content_model.dart';
import 'package:desgram_ui/domain/models/post/post_model.dart';
import 'package:desgram_ui/ui/app_widgets/image_user_avatar.dart';
import 'package:desgram_ui/ui/roots/main_page/main_page_navigator.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/comment_page/comment_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentWidget extends StatelessWidget {
  const CommentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<CommentViewModel>();
    var comments = viewModel.state.comments;
    return Scaffold(
      appBar: AppBar(
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(0.6),
          child: Divider(color: Colors.grey, height: 0.6, thickness: 0.6),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 24, fontWeight: FontWeight.w700),
        title: const Text("Комментарии"),
      ),
      body: RefreshIndicator(
        onRefresh: viewModel.asyncInit,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: viewModel.scrollController,
          slivers: [
            if (viewModel.post.description.isNotEmpty)
              SliverToBoxAdapter(
                  child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: ImageUserAvatar(
                                imageContentModel:
                                    viewModel.post.user.avatar == null
                                        ? null
                                        : ImageContentModel(imageCandidates: [
                                            viewModel.post.user.avatar!
                                          ]),
                                size: 50),
                          ),
                          Expanded(
                            flex: 5,
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      viewModel.mainPageNavigator
                                          .toAnotherAccountContent(
                                              userId: viewModel.post.user.id);
                                    },
                                    child: Text(
                                      viewModel.post.user.name,
                                      style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Text(
                                    viewModel.post.description,
                                    style: const TextStyle(fontSize: 17),
                                  ),
                                ]),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                      height: 1,
                      color: Colors.grey,
                    ),
                  ],
                ),
              )),
            SliverList(
                delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: GestureDetector(
                    onLongPress: () {
                      viewModel.showActionsOnComment(
                          commentModel: comments[index]);
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: ImageUserAvatar(
                                imageContentModel:
                                    comments[index].user.avatar == null
                                        ? null
                                        : ImageContentModel(imageCandidates: [
                                            comments[index].user.avatar!
                                          ]),
                                size: 50),
                          ),
                          Expanded(
                            flex: 4,
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      viewModel.mainPageNavigator
                                          .toAnotherAccountContent(
                                              userId: comments[index].user.id);
                                    },
                                    child: Text(
                                      comments[index].user.name,
                                      style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Text(
                                    comments[index].content,
                                    style: const TextStyle(fontSize: 17),
                                  ),
                                ]),
                          ),
                          Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  comments[index].hasLiked
                                      ? GestureDetector(
                                          onTap: () async {
                                            viewModel.unlikeComment(
                                                commentId: comments[index].id);
                                          },
                                          child: const Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                            size: 25,
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () async {
                                            viewModel.likeComment(
                                                commentId: comments[index].id);
                                          },
                                          child: const Icon(
                                            Icons.favorite_border,
                                            size: 25,
                                          ),
                                        ),
                                  Text(
                                    comments[index].amountLikes.toString(),
                                    style: const TextStyle(fontSize: 16),
                                  )
                                ],
                              ))
                        ],
                      ),
                    ),
                  )),
              childCount: comments.length,
            )),
            if (viewModel.state.isCommentsLoading)
              SliverToBoxAdapter(
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    )),
              )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey,
          ),
          const SizedBox(
            height: 7,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 5),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ImageUserAvatar(
                      imageContentModel: viewModel.currentUser?.avatar,
                      size: 50),
                ),
                Expanded(
                  flex: 7,
                  child: TextField(
                    controller: viewModel.commentController,
                    autofocus: true,
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        viewModel.addComment();
                      }
                    },
                    textInputAction: TextInputAction.send,
                    maxLines: 5,
                    minLines: 1,
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: TextButton(
                        onPressed: viewModel.state.content.isEmpty
                            ? null
                            : viewModel.addComment,
                        child: const Text("Отправить")))
              ],
            ),
          )
        ],
      )),
    );
  }

  static Widget create(
      {required MainPageNavigator mainPageNavigator,
      required PostModel postModel}) {
    return ChangeNotifierProvider(
      create: (context) => CommentViewModel(
          context: context,
          mainPageNavigator: mainPageNavigator,
          post: postModel),
      child: const CommentWidget(),
    );
  }
}
