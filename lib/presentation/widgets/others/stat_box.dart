import 'package:flutter/material.dart';
import 'package:project_management_app/core/theme/app_text_style.dart';

class StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const StatBox({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: AppTextStyle.appText18Bold.copyWith(color: color),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyle.appText11Medium.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
