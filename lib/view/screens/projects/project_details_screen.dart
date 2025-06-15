import 'package:flutter/material.dart';
import 'package:project_management_app/domain/models/project_model.dart';
import 'package:project_management_app/view/screens/media/image_gallary_screen.dart';
import 'package:project_management_app/view/screens/media/video_gallary_screen.dart';


class ProjectDetailScreen extends StatelessWidget {
  final Project project;

  const ProjectDetailScreen({required this.project});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(project.name),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.image), text: 'Images'),
              Tab(icon: Icon(Icons.video_library), text: 'Videos'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ImageGalleryScreen(projectId: project.id),
            VideoGalleryScreen(projectId: project.id),
          ],
        ),
      ),
    );
  }
}