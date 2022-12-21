import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main_page_navigator.dart';
import '../main_page_widget.dart';

class _ViewModel extends ChangeNotifier {
  final BuildContext context;

  _ViewModel({
    required this.context,
  });
}

class AnotherAccountContent extends StatelessWidget {
  final MainPageNavigator appPageNavigator;

  const AnotherAccountContent({super.key, required this.appPageNavigator});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Чей то аккаунт"),
      ),
      body: const Center(
          child: Icon(
        Icons.account_box,
        size: 100,
      )),
    );
  }

  static Widget create(MainPageNavigator appPageNavigator) {
    return ChangeNotifierProvider(
      create: (context) => _ViewModel(context: context),
      child: AnotherAccountContent(appPageNavigator: appPageNavigator),
    );
  }
}
