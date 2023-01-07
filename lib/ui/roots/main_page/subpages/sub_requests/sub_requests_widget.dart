import 'package:desgram_ui/ui/roots/main_page/main_page_navigator.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/blocked_users/blocked_users_view_model.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/sub_requests/sub_requests_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app_widgets/image_user_avatar.dart';

class SubRequestsWidget extends StatelessWidget {
  const SubRequestsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<SubRequestsViewModel>();
    var subRequests = viewModel.state.subRequests;
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
        title: const Text("Запросы на подписку"),
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
                      child: GestureDetector(
                        onTap: () {
                          viewModel.mainPageNavigator.toAnotherAccountContent(
                              userId: subRequests[index].id);
                        },
                        child: ImageUserAvatar.fromImageModel(
                            imageModel: subRequests[index].avatar, size: 45),
                      )),
                  Expanded(
                    flex: 4,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              viewModel.mainPageNavigator
                                  .toAnotherAccountContent(
                                      userId: subRequests[index].id);
                            },
                            child: Text(
                              subRequests[index].name,
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ]),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(8),
                          ),
                          onPressed: () => viewModel.acceptSubRequest(
                              user: subRequests[index]),
                          child: const Text("Подтвердить",
                              overflow: TextOverflow.ellipsis),
                        )),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: ElevatedButton(
                          onPressed: () => viewModel.deleteSubRequest(
                              user: subRequests[index]),
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(8),
                              foregroundColor: Colors.black,
                              backgroundColor:
                                  const Color.fromARGB(255, 205, 205, 205)),
                          child: const Text("Удалить",
                              overflow: TextOverflow.ellipsis),
                        )),
                  )
                ],
              ),
            ),
            childCount: subRequests.length,
          )),
          if (viewModel.state.isSubRequestsLoading)
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
      create: (context) => SubRequestsViewModel(
          context: context, mainPageNavigator: mainPageNavigator),
      child: const SubRequestsWidget(),
    );
  }
}
