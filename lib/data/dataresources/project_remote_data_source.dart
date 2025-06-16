import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_management_app/domain/models/project_model.dart';

class ProjectRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Project>> getProjects() async {
    final snapshot = await _firestore.collection('projects').get();

    return snapshot.docs.map((doc) {
      return Project.fromMap(doc.data());
    }).toList();
  }

  Future<List<Project>> searchProjects(String query) async {
    final doc =
        await _firestore
            .collection("projects")
            .where('name', isGreaterThanOrEqualTo: query)
            .where('name', isLessThan: '${query}z')
            .get();

    List<Project> list = [];
    for (var element in doc.docs) {
      final Project project = Project.fromMap(element.data());
      list.add(project);
    }

    return list;
  }
}
