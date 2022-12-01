import 'package:desgram_ui/data/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _ViewModel extends ChangeNotifier {
  final BuildContext context;
  final AuthService _authService = AuthService();

  _ViewModel({
    required this.context,
  });
}

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: const [
            Text("data 1"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data 1"),
          ],
        ),
      )),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: IconButton(
                    iconSize: 30,
                    onPressed: () {},
                    icon: const Icon(Icons.home_outlined)),
              ),
              Expanded(
                child: IconButton(
                    iconSize: 30,
                    onPressed: () {},
                    icon: const Icon(Icons.search_outlined)),
              ),
              Expanded(
                child: IconButton(
                    iconSize: 30,
                    onPressed: () {},
                    icon: const Icon(Icons.add_box_outlined)),
              ),
              Expanded(
                child: IconButton(
                    iconSize: 30,
                    onPressed: () {},
                    icon: const Icon(Icons.favorite_outline)),
              ),
              Expanded(
                child: IconButton(
                    iconSize: 30,
                    onPressed: () {},
                    icon: const Icon(Icons.account_circle)),
              )
            ],
          ),
        ),
      ),
    );
  }

  static Widget create() {
    return ChangeNotifierProvider(
      create: (context) => _ViewModel(context: context),
      child: const UserPage(),
    );
  }
}
