import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_management_app/data/dataresources/auth_remote_data_source.dart';

class AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepository({required this.authRemoteDataSource});

  Future<User?> login(String email, String password) async {
    try {
      return await authRemoteDataSource.login(email, password);
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> signUp(String email, String password, String name) async {
    try {
      return await authRemoteDataSource.signUp(email, password, name);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await authRemoteDataSource.resetPassword(email);
    } catch (e) {
      rethrow;
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
