import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_management_app/app.dart';
import 'package:project_management_app/core/firebase/firebase_options.dart';
import 'package:project_management_app/core/firebase/firebase_app_check_setup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFirebaseAppCheck();
  runApp(const MyApp());
}
