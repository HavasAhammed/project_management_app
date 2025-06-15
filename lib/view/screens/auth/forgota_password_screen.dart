import 'package:flutter/material.dart';
import 'package:project_management_app/domain/repositories/auth_repository.dart';
import 'package:project_management_app/view/widgets/auth_button.dart';
import 'package:project_management_app/view/widgets/auth_text_field.dart';
import 'package:provider/provider.dart';


class ForgotPasswordScreen extends StatelessWidget {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            AuthTextField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email,
            ),
            SizedBox(height: 24),
            AuthButton(
              text: 'Reset Password',
              onPressed: () {
                context.read<AuthRepository>().resetPassword(
                  _emailController.text,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Password reset email sent')),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}