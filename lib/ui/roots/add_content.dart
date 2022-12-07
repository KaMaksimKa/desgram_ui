import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:desgram_ui/ui/roots/main_page.dart';

class _ViewModel extends ChangeNotifier {
  final BuildContext context;

  _ViewModel({
    required this.context,
  });
}

class AddContent extends StatelessWidget {
  final ContentMainPageNavigator appPageNavigator;

  const AddContent({super.key, required this.appPageNavigator});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Добавить"),
      ),
      body: Center(
          child: IconButton(
              onPressed: () {
                appPageNavigator.toAnotherAccountContent();
              },
              icon: const Icon(
                Icons.add_box,
              ))),
    );
  }

  static Widget create(ContentMainPageNavigator appPageNavigator) {
    return ChangeNotifierProvider(
      create: (context) => _ViewModel(context: context),
      child: AddContent(appPageNavigator: appPageNavigator),
    );
  }
}
