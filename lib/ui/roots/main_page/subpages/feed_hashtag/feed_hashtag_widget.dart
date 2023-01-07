// ignore: unused_import
import 'package:desgram_ui/ui/roots/main_page/main_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app_widgets/post_feed_widget.dart';
import '../../main_page_navigator.dart';
import 'feed_hashtag_view_model.dart';

class FeedHashtagWidget extends StatelessWidget {
  const FeedHashtagWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<FeedHashtagViewModel>();
    var posts = viewModel.state.posts;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: viewModel.asyncInit,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: viewModel.scrollController,
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: false,
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(0.6),
                child: Divider(color: Colors.grey, height: 0.6, thickness: 0.6),
              ),
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              titleTextStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.w700),
              title: Text(viewModel.hashtag),
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
      ),
    );
  }

  static Widget create(
      {required MainPageNavigator mainPageNavigator, required String hashtag}) {
    return ChangeNotifierProvider(
      create: (context) => FeedHashtagViewModel(
          context: context,
          mainPageNavigator: mainPageNavigator,
          hashtag: hashtag),
      child: const FeedHashtagWidget(),
    );
  }
}
