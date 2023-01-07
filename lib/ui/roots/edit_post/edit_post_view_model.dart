import 'package:desgram_ui/domain/exceptions/exceptions.dart';
import 'package:desgram_ui/ui/common/no_network_dialog.dart';
import 'package:flutter/cupertino.dart';

import 'package:desgram_ui/data/services/post_service.dart';
import 'package:desgram_ui/domain/models/post/post_model.dart';
import 'package:desgram_ui/ui/app_navigator.dart';

class EditPostViewModelState {
  final bool isEditingPost;
  final int currentImageIndex;

  EditPostViewModelState({
    required this.isEditingPost,
    required this.currentImageIndex,
  });

  EditPostViewModelState copyWith({
    bool? isEditingPost,
    int? currentImageIndex,
  }) {
    return EditPostViewModelState(
      isEditingPost: isEditingPost ?? this.isEditingPost,
      currentImageIndex: currentImageIndex ?? this.currentImageIndex,
    );
  }
}

class EditPostViewModel extends ChangeNotifier {
  final PostModel postModel;
  final BuildContext context;
  final TextEditingController descriptionController = TextEditingController();
  final PostService _postService = PostService();

  EditPostViewModelState _state =
      EditPostViewModelState(isEditingPost: false, currentImageIndex: 0);

  EditPostViewModelState get state => _state;

  set state(EditPostViewModelState val) {
    _state = val;
    notifyListeners();
  }

  EditPostViewModel({
    required this.postModel,
    required this.context,
  }) {
    descriptionController.text = postModel.description;
  }

  Future editPost() async {
    state = state.copyWith(isEditingPost: true);
    try {
      await _postService.editPost(
          postId: postModel.id, description: descriptionController.text);
      AppNavigator.popPage();
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } finally {
      state = state.copyWith(isEditingPost: false);
    }
  }
}
