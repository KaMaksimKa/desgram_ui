import 'package:desgram_ui/domain/models/comment/comment_model.dart';
import 'package:desgram_ui/ui/roots/edit_comment/edit_comment_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_navigator.dart';

class EditCommentPage extends StatelessWidget {
  const EditCommentPage({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<EditCommentViewModel>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text("Редактировать"),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 26, fontWeight: FontWeight.w600),
        actions: [
          viewModel.state.isEditingComment
              ? Container(
                  alignment: Alignment.center,
                  height: 35,
                  width: 35,
                  child: const SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(),
                  ),
                )
              : IconButton(
                  color: Colors.blue,
                  iconSize: 35,
                  onPressed:
                      viewModel.checkField() ? viewModel.editComment : null,
                  icon: const Icon(Icons.check))
        ],
        leading: IconButton(
            iconSize: 35,
            onPressed:
                viewModel.state.isEditingComment ? null : AppNavigator.popPage,
            icon: const Icon(Icons.close)),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          TextField(
            autofocus: true,
            controller: viewModel.contentController,
            textInputAction: TextInputAction.newline,
            maxLines: null,
            minLines: 1,
            decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10)),
            style: const TextStyle(fontSize: 18),
          )
        ]),
      ),
    );
  }

  static Widget create({required CommentModel commentModel}) {
    return ChangeNotifierProvider(
      create: (context) =>
          EditCommentViewModel(commentModel: commentModel, context: context),
      child: const EditCommentPage(),
    );
  }
}
