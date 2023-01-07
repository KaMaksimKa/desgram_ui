import 'package:desgram_ui/ui/app_widgets/post_feed_widget.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/feed_user/feed_user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main_page_navigator.dart';

class FeedUserWidget extends StatelessWidget {
  const FeedUserWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<FeedUserWiewModel>();
    var posts = viewModel.state.posts;

    return Scaffold(
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: viewModel.scrollController,
        slivers: [
          const SliverAppBar(
            floating: true,
            pinned: false,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0.6),
              child: Divider(color: Colors.grey, height: 0.6, thickness: 0.6),
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            titleTextStyle: TextStyle(
                color: Colors.black, fontSize: 24, fontWeight: FontWeight.w700),
            title: Text("Публикации"),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, index) => PostFeedWidget(
              currentUserId: viewModel.currentUserId,
              post: posts[index],
              mainPageNavigator: viewModel.mainPageNavigator,
            ),
            childCount: posts.length,
          )),
          if (viewModel.state.isPostsLoading)
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

  static Widget create(MainPageNavigator mainPageNavigator, String userId) {
    return ChangeNotifierProvider(
      create: (context) => FeedUserWiewModel(
          context: context,
          mainPageNavigator: mainPageNavigator,
          userId: userId),
      child: const FeedUserWidget(),
    );
  }
}
