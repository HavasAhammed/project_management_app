import 'package:flutter/material.dart';
import 'package:project_management_app/presentation/widgets/appBar/custom_sub_app_bar.dart';
import 'package:project_management_app/presentation/widgets/button/primary_button.dart';
import 'package:project_management_app/presentation/widgets/snackBar/custom_snack_bar.dart';
import 'package:project_management_app/presentation/widgets/textField/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:project_management_app/domain/repositories/auth_repository.dart';
import 'package:project_management_app/core/theme/app_colors.dart';
import 'package:project_management_app/core/constants/height_and_width.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authRepo = context.read<AuthRepository>();
      final user = await authRepo.signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _nameController.text.trim(),
      );

      if (user != null) {
        CustomSnackBar.show(
          context: context,
          message: "Signup successful!",
          isSuccess: true,
        );
        Navigator.pop(context);
      } else {
        CustomSnackBar.show(
          context: context,
          message: "Signup failed. Try again.",
          isSuccess: false,
        );
      }
    } on Exception catch (e) {
      CustomSnackBar.show(
        context: context,
        message: e.toString().replaceFirst('Exception: ', ''),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(title: 'Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextField(
                controller: _nameController,
                labelText: 'Name',
                hintText: 'Enter Your Name',
                prefixIcon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              kHeight(18),
              CustomTextField(
                controller: _emailController,
                labelText: 'Email',
                hintText: 'Enter Your Email',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(
                    r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                  ).hasMatch(value.trim())) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              kHeight(18),
              CustomTextField(
                controller: _passwordController,
                labelText: 'Password',
                hintText: 'Enter Your Password',
                prefixIcon: Icons.lock_outline,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              kHeight(18),
              CustomTextField(
                controller: _confirmPasswordController,
                labelText: 'Confirm Password',
                hintText: 'Enter Your Confirm Password',
                prefixIcon: Icons.lock_outline,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              kHeight(28),
              PrimaryButton(
                label: 'Sign Up',
                isLoading: _isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
