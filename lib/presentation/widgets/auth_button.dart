import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final TextStyle? textStyle;

  const AuthButton({
    required this.text,
    required this.onPressed,
    this.color,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
        backgroundColor: color,
      ),
      onPressed: onPressed,
      child: Text(text, style: textStyle),
    );
  }
}