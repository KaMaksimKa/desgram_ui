import 'package:desgram_ui/domain/models/user/user_model.dart';
import 'package:flutter/material.dart';

class UserActionButton extends StatelessWidget {
  final UserModel userModel;
  final Function() unsubscribe;
  final Function() deleteRequest;
  final Function() subscribe;
  final Function() unblockUser;
  const UserActionButton(
      {super.key,
      required this.userModel,
      required this.unsubscribe,
      required this.deleteRequest,
      required this.subscribe,
      required this.unblockUser});

  @override
  Widget build(BuildContext context) {
    if (userModel.blockedByViewer) {
      return ElevatedButton(
        onPressed: unblockUser,
        style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            minimumSize: const Size.fromHeight(37),
            backgroundColor: Colors.grey.shade300,
            foregroundColor: Colors.black,
            elevation: 0,
            textStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        child: const Text("Разблокировать"),
      );
    } else if (userModel.hasBlockedViewer) {
      return ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            minimumSize: const Size.fromHeight(37),
            backgroundColor: Colors.grey.shade300,
            foregroundColor: Colors.black,
            elevation: 0,
            textStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        child: const Text("Вы заблокированы"),
      );
    } else if (userModel.followedByViewer) {
      return ElevatedButton(
        onPressed: unsubscribe,
        style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            minimumSize: const Size.fromHeight(37),
            backgroundColor: Colors.grey.shade300,
            foregroundColor: Colors.black,
            elevation: 0,
            textStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        child: const Text("Отписаться"),
      );
    } else if (userModel.hasRequestedViewer) {
      return ElevatedButton(
        onPressed: deleteRequest,
        style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            minimumSize: const Size.fromHeight(37),
            backgroundColor: Colors.grey.shade300,
            foregroundColor: Colors.black,
            elevation: 0,
            textStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        child: const Text("Запрошено"),
      );
    } else {
      return ElevatedButton(
        onPressed: subscribe,
        style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            minimumSize: const Size.fromHeight(37),
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            elevation: 0,
            textStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        child: const Text("Подписаться"),
      );
    }
  }
}
