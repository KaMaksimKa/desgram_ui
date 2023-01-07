import 'package:desgram_ui/ui/app_widgets/notification_row_widget.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/notifications/notifications_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main_page_navigator.dart';

class NotificationsWidget extends StatelessWidget {
  const NotificationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<NotificationsViewModel>();
    var notifications = viewModel.state.notifications;
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
          title: const Text("Уведомления"),
        ),
        body: RefreshIndicator(
          onRefresh: viewModel.refresh,
          child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: viewModel.scrollController,
              slivers: [
                if (viewModel.state.areSubRequestsExist)
                  SliverToBoxAdapter(
                      child: GestureDetector(
                    onTap: () {
                      viewModel.mainPageNavigator.toSubRequests();
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Container(
                                    height: 10,
                                    width: 10,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        "Запросы на подписку",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        "Подтвердить или игнорировать",
                                        style: TextStyle(
                                            fontSize: 17, color: Colors.grey),
                                      ),
                                    ]),
                              ),
                            ],
                          ),
                          const Divider(
                              color: Colors.black, height: 10, thickness: 0.9)
                        ],
                      ),
                    ),
                  )),
                SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: NotificationRowWidget(
                        deleteSubRequest: () => viewModel.deleteSubRequest(
                            notification: notifications[index]),
                        acceptSubRequest: () => viewModel.acceptSubRequest(
                            notification: notifications[index]),
                        notificationModel: notifications[index],
                        mainPageNavigator: viewModel.mainPageNavigator),
                  );
                }, childCount: notifications.length)),
              ]),
        ));
  }

  static Widget create(MainPageNavigator mainPageNavigator) {
    return ChangeNotifierProvider(
      create: (context) => NotificationsViewModel(
          context: context, mainPageNavigator: mainPageNavigator),
      child: const NotificationsWidget(),
    );
  }
}
