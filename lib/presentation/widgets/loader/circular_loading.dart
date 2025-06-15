import 'package:flutter/material.dart';
import 'package:project_management_app/core/theme/app_colors.dart';

Widget loader({Color? color, double? size, double? strokeWidth}) {
  return Center(
    child: SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth ?? 3,
        color: color ?? AppColors.primaryBlueColor,
      ),
    ),
  );
}
