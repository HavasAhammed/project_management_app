import 'package:flutter/material.dart';
import 'package:project_management_app/domain/repositories/auth_repository.dart';
import 'package:project_management_app/view/screens/auth/forgota_password_screen.dart';
import 'package:project_management_app/view/screens/auth/signup_screen.dart';
import 'package:project_management_app/view/widgets/auth_button.dart';
import 'package:project_management_app/view/widgets/auth_text_field.dart';
import 'package:provider/provider.dart';


class LoginScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            AuthTextField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email,
            ),
            SizedBox(height: 16),
            AuthTextField(
              controller: _passwordController,
              label: 'Password',
              icon: Icons.lock,
              obscureText: true,
            ),
            SizedBox(height: 24),
            AuthButton(
              text: 'Login',
              onPressed: () {
                context.read<AuthRepository>().login(
                  _emailController.text,
                  _passwordController.text,
                );
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                );
              },
              child: Text('Forgot Password?'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupScreen()),
                );
              },
              child: Text('Create New Account'),
            ),
          ],
        ),
      ),
    );
  }
}