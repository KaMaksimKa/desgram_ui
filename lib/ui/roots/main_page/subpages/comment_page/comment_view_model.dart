import 'package:desgram_ui/domain/exceptions/not_found_exception.dart';
import 'package:desgram_ui/ui/app_navigator.dart';
import 'package:desgram_ui/ui/common/no_network_dialog.dart';
import 'package:flutter/cupertino.dart';

import 'package:desgram_ui/data/services/post_service.dart';
import 'package:desgram_ui/data/services/user_service.dart';
import 'package:desgram_ui/domain/exceptions/exceptions.dart';
import 'package:desgram_ui/domain/models/comment/comment_model.dart';
import 'package:desgram_ui/domain/models/post/post_model.dart';
import 'package:desgram_ui/domain/models/user/user_model.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/subpage_view_model.dart';
import 'package:flutter/material.dart';

import '../../../../common/something_went_wrong_dialog.dart';

class CommentViewModelState {
  final List<CommentModel> comments;
  final bool isCommentsLoading;
  final String content;
  CommentViewModelState({
    required this.comments,
    required this.isCommentsLoading,
    required this.content,
  });

  CommentViewModelState copyWith({
    List<CommentModel>? comments,
    bool? isCommentsLoading,
    String? content,
  }) {
    return CommentViewModelState(
      comments: comments ?? this.comments,
      isCommentsLoading: isCommentsLoading ?? this.isCommentsLoading,
      content: content ?? this.content,
    );
  }
}

class CommentViewModel extends SubpageViewModel {
  final PostModel post;
  final UserService _userService = UserService();
  final PostService _postService = PostService();
  final TextEditingController commentController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  UserModel? currentUser;

  CommentViewModelState _state = CommentViewModelState(
      comments: [], isCommentsLoading: false, content: "");

  CommentViewModelState get state => _state;

  set state(CommentViewModelState val) {
    _state = val;
    notifyListeners();
  }

  CommentViewModel(
      {required super.context,
      required super.mainPageNavigator,
      required this.post}) {
    scrollController.addListener(_scrollListener);
    commentController.addListener(
      () {
        state = state.copyWith(content: commentController.text);
      },
    );
    asyncInit();
  }

  Future asyncInit() async {
    currentUser = await _userService.getCurrentUserFromDb();
    await _loadComments(isDeleteOld: true);
    notifyListeners();
  }

  Future _scrollListener() async {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      await _loadComments();
    }
  }

  Future _loadComments({bool isDeleteOld = false}) async {
    if (state.isCommentsLoading) {
      return;
    }

    state = state.copyWith(isCommentsLoading: true);
    try {
      List<CommentModel> comments =
          isDeleteOld ? [] : List.from(state.comments);
      comments.addAll(await _postService.getPostComments(
              postId: post.id, skip: comments.length, take: 20) ??
          []);
      state = state.copyWith(comments: comments);
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } catch (e) {
      showSomethingWentWrong(context: context);
    } finally {
      state = state.copyWith(isCommentsLoading: false);
    }
  }

  Future addComment() async {
    if (state.content.isEmpty) {
      return;
    }
    try {
      var comment = await _postService.addComment(
          postId: post.id, content: state.content);

      if (comment != null) {
        state.comments.insert(0, comment);
        state.copyWith(comments: state.comments);
      }
      commentController.text = "";
      state = state.copyWith(content: "");
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } catch (e) {
      showSomethingWentWrong(context: context);
    }
  }

  Future likeComment({required String commentId}) async {
    try {
      var amountLikes = await _postService.likeComment(commentId: commentId);
      var comment =
          state.comments.where((element) => element.id == commentId).first;

      comment.amountLikes = amountLikes ?? comment.amountLikes;
      comment.hasLiked = true;
      state = state.copyWith(comments: state.comments);
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } catch (e) {
      showSomethingWentWrong(context: context);
    }
  }

  Future unlikeComment({required String commentId}) async {
    try {
      var amountLikes = await _postService.unlikeComment(commentId: commentId);
      var comment =
          state.comments.where((element) => element.id == commentId).first;

      comment.amountLikes = amountLikes ?? comment.amountLikes;
      comment.hasLiked = false;
      state = state.copyWith(comments: state.comments);
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } catch (e) {
      showSomethingWentWrong(context: context);
    }
  }

  Future showActionsOnComment({required CommentModel commentModel}) async {
    var currentUserId = currentUser?.id;
    if (currentUserId == null) {
      return;
    }
    if (currentUserId != commentModel.user.id &&
        currentUserId != post.user.id) {
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            if (currentUserId == commentModel.user.id)
              TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await AppNavigator.toEditComment(
                        commentModel: commentModel);
                    asyncInit();
                  },
                  style:
                      ElevatedButton.styleFrom(foregroundColor: Colors.black),
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
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ))
                    ],
                  )),
            if (currentUserId == commentModel.user.id ||
                currentUserId == post.user.id)
              TextButton(
                  onPressed: () {
                    deleteComment(commentId: commentModel.id);
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.black),
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
      ),
    );
  }

  Future deleteComment({required String commentId}) async {
    try {
      await _postService.deleteComment(commentId: commentId);
      var comments = state.comments;
      comments.removeWhere((element) => element.id == commentId);
      state = state.copyWith(comments: comments);
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } on NotFoundException {
      var comments = state.comments;
      comments.removeWhere((element) => element.id == commentId);
      state = state.copyWith(comments: comments);
    } catch (e) {
      showSomethingWentWrong(context: context);
    }
  }
}
