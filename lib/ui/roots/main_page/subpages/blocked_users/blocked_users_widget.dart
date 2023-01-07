import 'package:desgram_ui/ui/roots/main_page/main_page_navigator.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/blocked_users/blocked_users_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app_widgets/image_user_avatar.dart';

class BlockedUsersWidget extends StatelessWidget {
  const BlockedUsersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<BlockedUsersViewModel>();
    var blockedUsers = viewModel.state.blockedUsers;
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
        title: const Text("Заблокированные аккаунты"),
      ),
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: viewModel.scrollController,
        slivers: [
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, index) => Padding(
              padding: const EdgeInsets.only(right: 5, top: 5),
              child: Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: ImageUserAvatar.fromImageModel(
                        imageModel: blockedUsers[index].avatar,
                        size: 45,
                      )),
                  Expanded(
                    flex: 7,
                    child: GestureDetector(
                        onTap: () {
                          viewModel.mainPageNavigator.toAnotherAccountContent(
                              userId: blockedUsers[index].id);
                        },
                        child: Text(
                          blockedUsers[index].name,
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w600),
                        )),
                  ),
                  Expanded(
                      flex: 3,
                      child: ElevatedButton(
                        onPressed: () {
                          viewModel.unblockUser(userId: blockedUsers[index].id);
                        },
                        child: const Text("Разблокировать"),
                      ))
                ],
              ),
            ),
            childCount: blockedUsers.length,
          )),
          if (viewModel.state.isBlockedUsersLoading)
            SliverToBoxAdapter(
              child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  )),
            )
        ],
      ),
    );
  }

  static Widget create({required MainPageNavigator mainPageNavigator}) {
    return ChangeNotifierProvider(
      create: (context) => BlockedUsersViewModel(
          context: context, mainPageNavigator: mainPageNavigator),
      child: const BlockedUsersWidget(),
    );
  }
}
