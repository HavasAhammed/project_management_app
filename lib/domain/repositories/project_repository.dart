import 'package:flutter/material.dart';
import 'package:project_management_app/data/dataresources/project_remote_data_source.dart';
import 'package:project_management_app/domain/models/project_model.dart';

class ProjectRepository extends ChangeNotifier {
  final ProjectRemoteDataSource projectRemoteDataSource;
  List<Project> _projects = [];
  bool _isLoading = true;

  ProjectRepository({required this.projectRemoteDataSource}) {
    loadProjects();
  }

  List<Project> get projects => _projects;
  bool get isLoading => _isLoading;

  Future<void> loadProjects() async {
    _isLoading = true;
    notifyListeners();
    _projects = await projectRemoteDataSource.getProjects();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchProjects(String query) async {
    _isLoading = true;
    notifyListeners();
    _projects = await projectRemoteDataSource.searchProjects(query);
    _isLoading = false;
    notifyListeners();
  }
}