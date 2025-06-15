import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_management_app/data/dataresources/auth_remote_data_source.dart';

class AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepository({required this.authRemoteDataSource});

  Future<User?> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password must not be empty');
    }
    try {
      return await authRemoteDataSource.login(email, password);
    } on FirebaseAuthException catch (e) {
      // Handle specific error codes for user-friendly messages
      String msg;
      switch (e.code) {
        case 'user-not-found':
          msg = 'No user found for that email.';
          break;
        case 'wrong-password':
          msg = 'Incorrect password. Please try again.';
          break;
        case 'invalid-email':
          msg = 'The email address is not valid.';
          break;
        case 'user-disabled':
          msg = 'This user has been disabled.';
          break;
        default:
          msg = e.message ?? 'Login failed.';
      }
      throw Exception(msg);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<User?> signUp(String email, String password, String name) async {
    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      throw Exception('All fields are required');
    }
    try {
      return await authRemoteDataSource.signUp(email, password, name);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Signup failed');
    } catch (e) {
      throw Exception('Signup failed: $e');
    }
  }

  Future<void> resetPassword(String email) async {
    if (email.isEmpty) {
      throw Exception('Email must not be empty');
    }
    try {
      await authRemoteDataSource.resetPassword(email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Reset password failed');
    } catch (e) {
      throw Exception('Reset password failed: $e');
    }
  }

  Future<void> logout() async {
    try {
      await authRemoteDataSource.logout();
    } catch (e) {
      rethrow;
    }
  }
}
