import 'package:flutter/material.dart';
import 'package:project_management_app/domain/models/project_model.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;

  const ProjectCard({
    required this.project,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(project.name),
        subtitle: Text(project.description),
        trailing: CircularProgressIndicator(
          value: project.progress / 100,
        ),
        onTap: onTap,
      ),
    );
  }
}