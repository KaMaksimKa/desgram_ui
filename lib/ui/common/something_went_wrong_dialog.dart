import 'package:flutter/material.dart';

void showSomethingWentWrong({required BuildContext context}) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        Future.delayed(const Duration(milliseconds: 600)).then((value) {
          Navigator.of(context).pop();
        });
        return const AlertDialog(
          title: Text("Что-то пошло не так."),
        );
      });
}
