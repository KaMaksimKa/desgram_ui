import 'package:desgram_ui/data/services/post_service.dart';
import 'package:desgram_ui/domain/exceptions/exceptions.dart';
import 'package:desgram_ui/ui/common/no_network_dialog.dart';
import 'package:flutter/cupertino.dart';

import 'package:desgram_ui/domain/models/comment/comment_model.dart';

import '../../app_navigator.dart';
import '../../common/something_went_wrong_dialog.dart';

class EditCommentViewModelState {
  final bool isEditingComment;

  EditCommentViewModelState({
    required this.isEditingComment,
  });

  EditCommentViewModelState copyWith({
    bool? isEditingComment,
  }) {
    return EditCommentViewModelState(
      isEditingComment: isEditingComment ?? this.isEditingComment,
    );
  }
}

class EditCommentViewModel extends ChangeNotifier {
  final CommentModel commentModel;
  final BuildContext context;
  final PostService _postService = PostService();
  final TextEditingController contentController = TextEditingController();
  EditCommentViewModelState _state =
      EditCommentViewModelState(isEditingComment: false);

  EditCommentViewModelState get state => _state;

  set state(EditCommentViewModelState val) {
    _state = val;
    notifyListeners();
  }

  EditCommentViewModel({
    required this.commentModel,
    required this.context,
  }) {
    contentController.addListener(() {
      notifyListeners();
    });
    contentController.text = commentModel.content;
  }

  bool checkField() {
    return contentController.text.isNotEmpty;
  }

  Future editComment() async {
    if (!checkField()) {
      return;
    }
    state = state.copyWith(isEditingComment: true);
    try {
      await _postService.editComment(
          commentId: commentModel.id, content: contentController.text);

      AppNavigator.popPage();
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } catch (e) {
      showSomethingWentWrong(context: context);
    } finally {
      state = state.copyWith(isEditingComment: false);
    }
  }
}
