import 'package:flutter/material.dart';
import 'package:project_management_app/core/constants/height_and_width.dart';
import 'package:project_management_app/core/theme/app_colors.dart';
import 'package:project_management_app/core/theme/app_text_style.dart';
import 'package:project_management_app/domain/repositories/auth_repository.dart';
import 'package:project_management_app/presentation/widgets/appBar/custom_sub_app_bar.dart';
import 'package:project_management_app/presentation/widgets/button/primary_button.dart';
import 'package:project_management_app/presentation/widgets/textField/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:project_management_app/presentation/widgets/snackBar/custom_snack_bar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(title: 'Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                RichText(
                  text: TextSpan(
                    style: AppTextStyle.appText14Regular.copyWith(
                      color: AppColors.textPrimaryColor,
                    ),
                    children: [
                      TextSpan(text: 'Enter your '),
                      TextSpan(
                        text: 'Email Address',
                        style: AppTextStyle.appText14Bold.copyWith(
                          color: AppColors.textPrimaryColor,
                        ),
                      ),
                      TextSpan(text: ' to receive a password reset link.'),
                    ],
                  ),
                ),
              ],
            ),
            kHeight(20),
            CustomTextField(
              isReset: true,
              controller: _emailController,
              labelText: 'Email',
              hintText: "Enter Your Email",
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            kHeight(24),
            PrimaryButton(
              label: 'Reset Password',
              isLoading: _isLoading,
              onPressed:
                  _isLoading
                      ? null
                      : () async {
                        FocusScope.of(context).unfocus();
                        if (_emailController.text.isEmpty) {
                          CustomSnackBar.show(
                            context: context,
                            message: 'Please enter your email',
                            isSuccess: false,
                          );
                          return;
                        }
                        setState(() => _isLoading = true);
                        try {
                          await context.read<AuthRepository>().resetPassword(
                            _emailController.text,
                          );
                          CustomSnackBar.show(
                            context: context,
                            message: 'Password reset email sent',
                            isSuccess: true,
                          );
                          Navigator.pop(context);
                        } on Exception catch (e) {
                          CustomSnackBar.show(
                            context: context,
                            message: e.toString().replaceFirst(
                              'Exception: ',
                              '',
                            ),
                            isSuccess: false,
                          );
                        } catch (e) {
                          CustomSnackBar.show(
                            context: context,
                            message: e.toString(),
                            isSuccess: false,
                          );
                        } finally {
                          setState(() => _isLoading = false);
                        }
                      },
            ),
          ],
        ),
      ),
    );
  }
}
