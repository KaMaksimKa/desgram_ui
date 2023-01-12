import 'package:desgram_ui/ui/app_widgets/image_user_avatar.dart';
import 'package:desgram_ui/ui/roots/main_page/main_page_navigator.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/subscriptions/subscriptions_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubscriptionsWidget extends StatelessWidget {
  const SubscriptionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<SubscriptionsViewModel>();
    var userModel = viewModel.user;
    var followers = viewModel.state.followers;
    var following = viewModel.state.following;
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 7, bottom: 15),
                child: Row(
                  children: [
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        viewModel.state = viewModel.state.copyWith(
                            subscriptionType: SubscriptionType.followers);
                      },
                      child: Text(
                        "Подписчики",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: viewModel.state.subscriptionType ==
                                    SubscriptionType.followers
                                ? Colors.black
                                : Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    )),
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        viewModel.state = viewModel.state.copyWith(
                            subscriptionType: SubscriptionType.followings);
                      },
                      child: Text(
                        "Подписки",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            color: viewModel.state.subscriptionType ==
                                    SubscriptionType.followings
                                ? Colors.black
                                : Colors.grey,
                            fontWeight: FontWeight.w500),
                      ),
                    )),
                  ],
                ),
              ),
              const Divider(color: Colors.grey, height: 1, thickness: 1)
            ],
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 24, fontWeight: FontWeight.w700),
        title: userModel == null
            ? const CircularProgressIndicator()
            : Text(userModel.name),
      ),
      body: SizedBox(
          child: PageView(
        controller: viewModel.pageController,
        onPageChanged: (value) {
          viewModel.state = viewModel.state.copyWith(
              subscriptionType: value == 0
                  ? SubscriptionType.followers
                  : SubscriptionType.followings);
        },
        children: [
          RefreshIndicator(
              onRefresh: viewModel.refreshFollowers,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: viewModel.followersScrollController,
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
                                imageModel: followers[index].avatar,
                                size: 45,
                              )),
                          Expanded(
                            flex: 7,
                            child: GestureDetector(
                                onTap: () {
                                  viewModel.mainPageNavigator
                                      .toAnotherAccountContent(
                                          userId: followers[index].id);
                                },
                                child: Text(
                                  followers[index].name,
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600),
                                )),
                          ),
                          Expanded(
                              flex: 3,
                              child: viewModel.userId == viewModel.currentUserId
                                  ? ElevatedButton(
                                      onPressed: () {
                                        viewModel.deleteFollower(
                                            followerId: followers[index].id);
                                      },
                                      child: const Text("Удалить"),
                                    )
                                  : Container())
                        ],
                      ),
                    ),
                    childCount: followers.length,
                  )),
                  if (viewModel.state.isFollowersLoading)
                    SliverToBoxAdapter(
                      child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          )),
                    )
                ],
              )),
          RefreshIndicator(
              onRefresh: viewModel.refreshFollowing,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: viewModel.followingScrollController,
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
                                imageModel: following[index].avatar,
                                size: 45,
                              )),
                          Expanded(
                            flex: 6,
                            child: GestureDetector(
                                onTap: () {
                                  viewModel.mainPageNavigator
                                      .toAnotherAccountContent(
                                          userId: following[index].id);
                                },
                                child: Text(
                                  following[index].name,
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600),
                                )),
                          ),
                          Expanded(
                            flex: 4,
                            //  child: ElevatedButton(
                            //     onPressed: () {},
                            //     child: Text("Подписки"),
                            //   )
                            child: Container(),
                          )
                        ],
                      ),
                    ),
                    childCount: following.length,
                  )),
                  if (viewModel.state.isFollowingLoading)
                    SliverToBoxAdapter(
                      child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          )),
                    )
                ],
              ))
        ],
      )),
    );
  }

  static Widget create(
      {required MainPageNavigator mainPageNavigator,
      required SubscriptionType subscriptionType,
      required String userId}) {
    return ChangeNotifierProvider(
      create: (context) => SubscriptionsViewModel(
          context: context,
          mainPageNavigator: mainPageNavigator,
          subscriptionType: subscriptionType,
          userId: userId),
      child: const SubscriptionsWidget(),
    );
  }
}
