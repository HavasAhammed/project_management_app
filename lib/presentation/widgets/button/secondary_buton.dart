import 'package:flutter/material.dart';
import 'package:project_management_app/core/theme/app_colors.dart';
import 'package:project_management_app/core/theme/app_text_style.dart';
import 'package:project_management_app/presentation/widgets/loader/circular_loading.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    this.buttonColor,
    this.labelColor,
    this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final Color? buttonColor;
  final Color? labelColor;
  final bool isLoading;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? () {} : onPressed,
      style: TextButton.styleFrom(
        backgroundColor: buttonColor ?? AppColors.buttonGreyColor,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(),
      ),
      child:
          isLoading
              ? loader(color: AppColors.whiteColor, size: 30)
              : Text(
                label,
                style: AppTextStyle.appText11Regular.apply(
                  color: labelColor ?? AppColors.textPrimaryColor,
                ),
              ),
    );
  }
}
