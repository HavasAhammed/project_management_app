import 'package:flutter/material.dart';
import 'package:project_management_app/core/theme/app_colors.dart';
import 'package:project_management_app/core/theme/app_text_style.dart';
import 'package:project_management_app/presentation/widgets/loader/circular_loading.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    this.isLoading = false,
    required this.label,
    this.width,
    this.height,
    this.radius,
    this.labelSize,
    this.buttonColor,
    this.labelColor,
    this.borderColor,
    this.isBoarder = false,
    this.icon,
    required this.onPressed,
  });

  final String label;
  final double? width;
  final double? height;
  final double? radius;
  final double? labelSize;
  final Color? buttonColor;
  final Color? labelColor;
  final Color? borderColor;
  final bool isLoading;
  final bool isBoarder;
  final Widget? icon;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor ?? AppColors.primaryBlueColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 12),
          ),
        ),
        onPressed: isLoading ? () {} : onPressed,
        child:
            isLoading
                ? loader(color: AppColors.whiteColor, size: 30)
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[icon!, const SizedBox(width: 8)],
                    Text(
                      label,
                      style: AppTextStyle.appText16Bold.apply(
                        color: labelColor ?? AppColors.whiteColor,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
