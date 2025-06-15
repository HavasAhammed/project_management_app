import 'package:flutter/material.dart';
import 'package:project_management_app/core/constants/height_and_width.dart';
import 'package:project_management_app/core/theme/app_colors.dart';

showCustomDialog(
  BuildContext context, {
  String? title,
  @required String? message,
  VoidCallback? onCompleted,
  bool useRootNavigator = false,
  bool showCancelButton = false,
  String? button1,
  String? button2,
  VoidCallback? onCancelled,
  Color? button1BgColor,
  Color? button2BgColor,
  Color? button1Color,
  Color? button2Color,
  Color? messageColor,
}) {
  showDialog(
    context: context,
    useRootNavigator: useRootNavigator,
    barrierDismissible: false,
    builder:
        (context) => AlertDialog(
          title: Center(
            child: Text(title ?? "", style: TextStyle(color: Colors.black)),
          ),
          content: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Text(
              message!,
              style: TextStyle(color: messageColor ?? Colors.red[800]),
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: button2BgColor ?? AppColors.primaryColor,
                    elevation: 0,
                  ),
                  child: Text(
                    button2 ?? "No",
                    style: TextStyle(color: button2Color ?? Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    if (onCancelled != null) {
                      onCancelled();
                    }
                  },
                ),
                kWidth(8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: button1BgColor ?? Colors.red[800],
                  ),
                  child: Text(
                    button1 ?? "Yes",
                    style: TextStyle(color: button1Color ?? Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    if (onCompleted != null) {
                      onCompleted();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
  );
}
