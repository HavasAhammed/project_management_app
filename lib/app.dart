import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_management_app/data/dataresources/auth_remote_data_source.dart';
import 'package:project_management_app/data/dataresources/media_remote_data_source.dart';
import 'package:project_management_app/data/dataresources/project_remote_data_sorce.dart';
import 'package:project_management_app/domain/repositories/auth_repository.dart';
import 'package:project_management_app/domain/repositories/medi_repository.dart';
import 'package:project_management_app/domain/repositories/project_repository.dart';
import 'package:project_management_app/view/screens/auth/login_screen.dart';
import 'package:project_management_app/view/screens/projects/projects_screen.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthRepository>(
          create:
              (_) =>
                  AuthRepository(authRemoteDataSource: AuthRemoteDataSource()),
        ),

        ChangeNotifierProvider<ProjectRepository>(
          create:
              (_) => ProjectRepository(
                projectRemoteDataSource: ProjectRemoteDataSource(),
              ),
        ),

        Provider<MediaRepository>(
          create:
              (_) => MediaRepository(
                mediaRemoteDataSource: MediaRemoteDataSource(),
              ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Project Management App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              return snapshot.hasData ? ProjectsScreen() : LoginScreen();
            }
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          },
        ),
      ),
    );
  }
}
