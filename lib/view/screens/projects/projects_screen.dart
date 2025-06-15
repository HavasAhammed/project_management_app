import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_management_app/domain/models/project_model.dart';
import 'package:project_management_app/domain/repositories/auth_repository.dart';
import 'package:project_management_app/domain/repositories/project_repository.dart';
import 'package:project_management_app/view/screens/charts/charts_screen.dart';
import 'package:project_management_app/view/screens/map/map_screen.dart';
import 'package:project_management_app/view/screens/projects/project_details_screen.dart';
import 'package:project_management_app/view/widgets/project_card.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<ProjectRepository>();

    return Scaffold(
      appBar: AppBar(
        title: Text('My Projects'),
        actions: [
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => MapScreen()));
            },
          ),
          IconButton(
            icon: Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ChartsScreen()));
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              context.read<AuthRepository>().logout();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search projects...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                context.read<ProjectRepository>().searchProjects(value);
              },
            ),
          ),
          Expanded(
            child: repo.isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: repo.projects.length,
                    itemBuilder: (context, index) {
                      final project = repo.projects[index];
                      return ProjectCard(
                        project: project,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProjectDetailScreen(project: project),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}