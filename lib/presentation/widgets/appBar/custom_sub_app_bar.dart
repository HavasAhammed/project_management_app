import 'package:flutter/material.dart';
import 'package:project_management_app/core/theme/app_text_style.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.colors,
    this.showBack = true,
    this.actions,
    this.centerTitle = true,
  });

  final String title;
  final List<Color>? colors;
  final bool showBack;
  final List<Widget>? actions;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading:
          showBack
              ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              )
              : null,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors ?? [Color(0xFF012CA0), Color(0xFF001A63)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
      title: Text(
        title,
        style: AppTextStyle.appText17Bold.apply(color: Colors.white),
      ),
      centerTitle: centerTitle,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: actions,
    );
  }
}
