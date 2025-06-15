import 'package:flutter/material.dart';
import 'package:project_management_app/core/constants/height_and_width.dart';
import 'package:project_management_app/core/theme/app_colors.dart';
import 'package:project_management_app/core/theme/app_text_style.dart';

void showCustomDialog(
  BuildContext context, {
  required String title,
  required String message,
  VoidCallback? onCompleted,
  bool isLoading = false,
  String cancelLabel = 'Cancel',
  String confirmLabel = 'OK',
  Color? confirmColor,
  Color? confirmLabelColor,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (_) => AlertDialog(
          backgroundColor: Colors.white, // Set card color to white
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 24,
            horizontal: 32,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primaryRedColor,
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Icon(
                  Icons.logout,
                  color: AppColors.primaryRedColor,
                  size: 32,
                ),
              ),
              kHeight(16),
              Text(
                title,
                style: AppTextStyle.appText15Bold.apply(
                  color: AppColors.textGreyColor,
                ),
              ),
              kHeight(8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyle.appText11Regular.apply(color: Colors.black),
              ),
              kHeight(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonGreyColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        cancelLabel,
                        style: AppTextStyle.appText13Bold,
                      ),
                    ),
                  ),
                  kWidth(12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            confirmColor ?? AppColors.primaryRedColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed:
                          isLoading
                              ? null
                              : () {
                                Navigator.pop(context);
                                if (onCompleted != null) onCompleted();
                              },
                      child:
                          isLoading
                              ? SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : Text(
                                confirmLabel,
                                style: AppTextStyle.appText13Bold.apply(
                                  color: confirmLabelColor ?? Colors.white,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
  );
}
