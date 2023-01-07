import 'package:flutter/material.dart';

void showNoNetworkDialog({required BuildContext context}) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        Future.delayed(const Duration(milliseconds: 600)).then((value) {
          Navigator.of(context).pop();
        });
        return const AlertDialog(
          title: Text("Нет сети."),
        );
      });
}
