import 'package:desgram_ui/ui/roots/main_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _ViewModel extends ChangeNotifier {
  final BuildContext context;

  _ViewModel({
    required this.context,
  });
}

class NotificationsContent extends StatelessWidget {
  final ContentMainPageNavigator appPageNavigator;

  const NotificationsContent({super.key, required this.appPageNavigator});

  @override
  Widget build(BuildContext context) {
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
      body: Center(
          child: IconButton(
              onPressed: () {
                appPageNavigator.toAnotherAccountContent();
              },
              icon: const Icon(
                Icons.favorite,
              ))),
    );
  }

  static Widget create(ContentMainPageNavigator appPageNavigator) {
    return ChangeNotifierProvider(
      create: (context) => _ViewModel(context: context),
      child: NotificationsContent(appPageNavigator: appPageNavigator),
    );
  }
}
