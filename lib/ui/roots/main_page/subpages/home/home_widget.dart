// ignore: unused_import
import 'package:desgram_ui/ui/roots/main_page/main_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app_widgets/post_feed_widget.dart';
import '../../main_page_navigator.dart';
import 'home_view_model.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<HomeViewModel>();
    var posts = viewModel.state.posts;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: viewModel.asyncInit,
        child: CustomScrollView(
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
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.w700),
              title: Text("Desgram"),
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

  static Widget create(MainPageNavigator mainPageNavigator) {
    return ChangeNotifierProvider(
      create: (context) =>
          HomeViewModel(context: context, mainPageNavigator: mainPageNavigator),
      child: const HomeWidget(),
    );
  }
}
