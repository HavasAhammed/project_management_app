import 'package:flutter/material.dart';
import 'package:project_management_app/core/theme/app_colors.dart';

class CustomSnackBar {
  static void show({
    required BuildContext context,
    required String message,
    bool isSuccess = true,
    Duration duration = const Duration(seconds: 3),
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            isSuccess ? Icons.check_circle : Icons.error,
            color: Colors.white,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(message, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
      backgroundColor:
          isSuccess ? AppColors.successColor : AppColors.errorColor,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: duration,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
