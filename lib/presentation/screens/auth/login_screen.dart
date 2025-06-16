import 'package:flutter/material.dart';
import 'package:project_management_app/core/theme/app_colors.dart';
import 'package:project_management_app/domain/repositories/auth_repository.dart';
import 'package:project_management_app/presentation/screens/auth/forgota_password_screen.dart';
import 'package:project_management_app/presentation/screens/auth/signup_screen.dart';
import 'package:project_management_app/presentation/widgets/appBar/custom_sub_app_bar.dart';
import 'package:project_management_app/presentation/widgets/button/primary_button.dart';
import 'package:project_management_app/presentation/widgets/textField/custom_text_field.dart';
import 'package:project_management_app/core/theme/app_text_style.dart';
import 'package:project_management_app/core/constants/height_and_width.dart';
import 'package:provider/provider.dart';
import 'package:project_management_app/presentation/widgets/snackBar/custom_snack_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(title: 'Login', showBack: false),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  hintText: "Enter Your Email",
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                kHeight(16),
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  hintText: "Enter Your Password",
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                ),
                kHeight(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: AppTextStyle.appText13Bold.copyWith(
                          color: AppColors.primaryBlueColor,
                        ),
                      ),
                    ),
                  ],
                ),
                kHeight(32),
                PrimaryButton(
                  label: 'Login',
                  isLoading: _isLoading,
                  onPressed:
                      _isLoading
                          ? null
                          : () async {
                            FocusScope.of(context).unfocus();
                            if (_emailController.text.isEmpty ||
                                _passwordController.text.isEmpty) {
                              CustomSnackBar.show(
                                context: context,
                                message: 'Please enter email and password',
                                isSuccess: false,
                              );
                              return;
                            }
                            setState(() => _isLoading = true);
                            try {
                              await context.read<AuthRepository>().login(
                                _emailController.text,
                                _passwordController.text,
                              );
                              CustomSnackBar.show(
                                context: context,
                                message: 'Login successful!',
                                isSuccess: true,
                              );
                            } catch (e) {
                              CustomSnackBar.show(
                                context: context,
                                message:
                                    e is Exception
                                        ? e.toString().replaceFirst(
                                          'Exception: ',
                                          '',
                                        )
                                        : e.toString(),
                                isSuccess: false,
                              );
                            } finally {
                              setState(() => _isLoading = false);
                            }
                          },
                ),
                kHeight(12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: AppTextStyle.appText14Regular.copyWith(
                        color: AppColors.textSecondaryColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignupScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: AppTextStyle.appText13Bold.copyWith(
                          color: AppColors.primaryBlueColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
