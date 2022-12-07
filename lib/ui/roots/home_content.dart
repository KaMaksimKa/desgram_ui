import 'package:desgram_ui/ui/roots/main_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _ViewModel extends ChangeNotifier {
  final BuildContext context;

  _ViewModel({
    required this.context,
  });
}

class HomeContent extends StatelessWidget {
  final ContentMainPageNavigator appPageNavigator;

  const HomeContent({super.key, required this.appPageNavigator});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Главная"),
      ),
      body: Center(
          child: IconButton(
              onPressed: () {
                appPageNavigator.toAnotherAccountContent();
              },
              icon: const Icon(
                Icons.home,
              ))),
    );
  }

  static Widget create(ContentMainPageNavigator appPageNavigator) {
    return ChangeNotifierProvider(
      create: (context) => _ViewModel(context: context),
      child: HomeContent(appPageNavigator: appPageNavigator),
    );
  }
}
