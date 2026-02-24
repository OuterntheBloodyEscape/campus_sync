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
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 0, 10, 0),
              child: Icon(
                ((goodMessage) ? (Icons.verified) : (Icons.dangerous_outlined)),
                color: ((goodMessage) ? (Colors.green) : (Colors.red)),
              ),
            ),
            Text(
              message,
              style: TextStyle(
                color: ((goodMessage) ? (Colors.green) : (Colors.red)),
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
