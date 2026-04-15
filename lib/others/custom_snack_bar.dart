import 'package:flutter/material.dart';

class CustomSnackBar {
  const CustomSnackBar();

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBarMessage({
    required BuildContext context,
    required String message,
    required bool goodMessage,
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 0, 10, 0),
              child: Icon(
                ((goodMessage) ? (Icons.verified) : (Icons.dangerous_outlined)),
                color: ((goodMessage) ? (Colors.green) : (Colors.red)),
              ),
            ),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: ((goodMessage) ? (Colors.green) : (Colors.red)),
                ),
                softWrap: true,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xff303030),
        behavior: SnackBarBehavior.floating,
        elevation: 3,
      ),
    );
  }
}
