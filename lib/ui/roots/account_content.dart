import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:desgram_ui/data/services/auth_service.dart';
import 'package:desgram_ui/data/services/post_service.dart';
import 'package:desgram_ui/domain/models/post_model.dart';
import 'package:desgram_ui/domain/models/user_model.dart';
import 'package:desgram_ui/inrernal/dependencies/api_module.dart';
import 'package:desgram_ui/ui/app_navigator.dart';
import 'package:desgram_ui/ui/roots/image_user_avatar.dart';

import '../../data/services/user_service.dart';
import 'main_page.dart';

class _ViewModelState {
  final UserModel? currentUserModel;
  final List<PostModel> posts;
  final bool isPostsLoading;

  const _ViewModelState({
    required this.currentUserModel,
    required this.posts,
    required this.isPostsLoading,
  });

  _ViewModelState copyWith({
    UserModel? currentUserModel,
    List<PostModel>? posts,
    bool? isPostsLoading,
  }) {
    return _ViewModelState(
      currentUserModel: currentUserModel ?? this.currentUserModel,
      posts: posts ?? this.posts,
      isPostsLoading: isPostsLoading ?? this.isPostsLoading,
    );
  }
}

class _ViewModel extends ChangeNotifier {
  final BuildContext context;
  final ContentMainPageNavigator appPageNavigator;
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final PostService _postService = PostService();
  ScrollController scrollController = ScrollController();

  _ViewModelState _state = const _ViewModelState(
    currentUserModel: null,
    posts: [],
    isPostsLoading: false,
  );
  _ViewModelState get state => _state;
  set state(_ViewModelState val) {
    _state = val;
    notifyListeners();
  }

  _ViewModel({
    required this.context,
    required this.appPageNavigator,
  }) {
    scrollController.addListener(_scrollListener);
    asyncInit();
  }

  void _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      loadPosts();
    }
    if (scrollController.offset <= scrollController.position.minScrollExtent &&
        !scrollController.position.outOfRange) {}
  }

  Future loadPosts() async {
    if (state.isPostsLoading) {
      return;
    }
    state = state.copyWith(isPostsLoading: true);
    var userModel = state.currentUserModel;
    List<PostModel> newPosts = List.from(state.posts);

    if (userModel != null) {
      newPosts.addAll(await _postService.getPostsByUserId(
              userId: userModel.id, skip: state.posts.length, take: 12) ??
          []);
    }
    state = state.copyWith(isPostsLoading: false, posts: newPosts);
  }

  Future asyncInit() async {
    state = state.copyWith(
        currentUserModel: await _userService.getCurrentUser(),
        isPostsLoading: false,
        posts: []);
    await loadPosts();
  }

  void _logout() {
    _authService.logout();
    AppNavigator.toAuth(isRemoveUntil: true);
  }

  void showAccountMenu() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                height: 4,
                width: 40,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 67, 67, 67),
                    borderRadius: BorderRadius.all(Radius.circular(4))),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    alignment: Alignment.centerLeft,
                    minimumSize: const Size.fromHeight(50),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {},
                  icon: const Icon(
                    Icons.settings_outlined,
                    size: 30,
                  ),
                  label: const Text(
                    "Настройки",
                  )),
              TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    alignment: Alignment.centerLeft,
                    minimumSize: const Size.fromHeight(50),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: _logout,
                  icon: const Icon(
                    Icons.logout_outlined,
                    size: 30,
                  ),
                  label: const Text(
                    "Выйти из аккаунта",
                  )),
              const SizedBox(
                height: 20,
              ),
            ]),
          );
        });
    notifyListeners();
  }

  void toEditProfilePage() {
    AppNavigator.toEditProfilePage();
  }
}

class AccountContent extends StatelessWidget {
  const AccountContent({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();
    var userModel = viewModel.state.currentUserModel;
    return Scaffold(
      appBar: AppBar(
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(0.6),
          child: Divider(color: Colors.grey, height: 0.6, thickness: 0.6),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 24, fontWeight: FontWeight.w700),
        title: userModel == null
            ? const CircularProgressIndicator()
            : Text(userModel.name),
        actions: [
          IconButton(
            onPressed: viewModel.showAccountMenu,
            icon: const Icon(Icons.menu),
            color: Colors.black,
          )
        ],
      ),
      body: userModel == null
          ? const CircularProgressIndicator()
          : RefreshIndicator(
              onRefresh: viewModel.asyncInit,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: viewModel.scrollController,
                slivers: <Widget>[
                  SliverList(
                      delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: Column(children: [
                        Row(
                          children: [
                            Expanded(
                              child: ImageUserAvatar(
                                imageContentModel: userModel.avatar,
                                size: 100,
                              ),
                            ),
                            Expanded(
                                flex: 2,
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: TextButton(
                                      style: TextButton.styleFrom(
                                          foregroundColor: Colors.black),
                                      onPressed: () {},
                                      child: Column(
                                        children: [
                                          Text(
                                            "${userModel.amountPosts}",
                                            style: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const Text("Публик...")
                                        ],
                                      ),
                                    )),
                                    Expanded(
                                        child: TextButton(
                                      style: TextButton.styleFrom(
                                          foregroundColor: Colors.black),
                                      onPressed: () {},
                                      child: Column(
                                        children: [
                                          Text(
                                            "${userModel.amountFollowers}",
                                            style: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const Text("Публик...")
                                        ],
                                      ),
                                    )),
                                    Expanded(
                                        child: TextButton(
                                      style: TextButton.styleFrom(
                                          foregroundColor: Colors.black),
                                      onPressed: () {},
                                      child: Column(
                                        children: [
                                          Text(
                                            "${userModel.amountFollowing}",
                                            style: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const Text("Публик...")
                                        ],
                                      ),
                                    )),
                                  ],
                                ))
                          ],
                        ),
                        ElevatedButton(
                          onPressed: viewModel.toEditProfilePage,
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              minimumSize: const Size.fromHeight(37),
                              backgroundColor: Colors.grey.shade300,
                              foregroundColor: Colors.black,
                              elevation: 0,
                              textStyle: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700)),
                          child: const Text("Редактировать профиль"),
                        ),
                      ]),
                    )
                  ])),
                  const SliverAppBar(
                    backgroundColor: Color.fromRGBO(250, 250, 250, 1),
                    pinned: true,
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(0.6),
                      child: Divider(
                          color: Colors.grey, height: 0.6, thickness: 0.6),
                    ),
                    flexibleSpace: Center(
                        child: Icon(
                      Icons.grid_on,
                      size: 30,
                    )),
                  ),
                  SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      childAspectRatio: 1.0,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(baseUrl +
                                      viewModel
                                          .state
                                          .posts[index]
                                          .imageContents[0]
                                          .imageCandidates[0]
                                          .url))),
                        );
                      },
                      childCount: viewModel.state.posts.length,
                    ),
                  ),
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

  static Widget create(ContentMainPageNavigator appPageNavigator) {
    return ChangeNotifierProvider(
      create: (context) =>
          _ViewModel(context: context, appPageNavigator: appPageNavigator),
      child: const AccountContent(),
    );
  }
}
