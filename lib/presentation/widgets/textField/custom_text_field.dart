import 'package:flutter/material.dart';
import 'package:project_management_app/core/theme/app_colors.dart';
import 'package:project_management_app/core/theme/app_text_style.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.controller,
    required this.labelText,
    required this.prefixIcon,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    this.hintText,
    this.isReset = false,
    this.onChanged,
  });

  final TextEditingController? controller;
  final String labelText;
  final String? hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool isReset;
  final void Function(String)? onChanged;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.isReset
            ? SizedBox()
            : Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 6),
              child: Text(
                widget.labelText,
                style: AppTextStyle.appText14Medium,
              ),
            ),
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          style: AppTextStyle.appText13Regular,
          keyboardType: widget.keyboardType,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppTextStyle.appText13Regular.apply(
              color: AppColors.textHintColor,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(widget.prefixIcon, color: AppColors.iconColor),
            ),
            suffixIcon:
                widget.obscureText
                    ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.iconColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                    : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide.none,
            ),
            // enabledBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(7),
            //   borderSide: BorderSide.none,
            // ),
            // focusedBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(7),
            //   borderSide: BorderSide(color: AppColors.primaryBlueColor, width: 1.5),
            // ),
            // errorBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(7),
            //   borderSide: BorderSide(color: AppColors.primaryRedColor, width: 1),
            // ),
          ),
          validator:
              widget.validator ??
              (v) => v == null || v.trim().isEmpty ? 'Name is required' : null,
        ),
      ],
    );
  }
}
