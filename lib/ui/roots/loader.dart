import 'package:desgram_ui/data/services/auth_service.dart';
import 'package:desgram_ui/ui/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _ViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  _ViewModel() {
    _asyncInint();
  }

  void _asyncInint() async {
    if (await _authService.checkAuth()) {
      AppNavigator.toUserPage(isRemoveUntil: true);
    } else {
      AppNavigator.toAuth();
    }
  }
}

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  static Widget create() {
    return ChangeNotifierProvider(
      create: (context) => _ViewModel(),
      lazy: false,
      child: const Loader(),
    );
  }
}
