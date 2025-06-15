import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_management_app/domain/models/project_model.dart';
import 'package:project_management_app/domain/repositories/project_repository.dart';
import 'package:project_management_app/view/screens/projects/project_details_screen.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final projectRepo = context.watch<ProjectRepository>();
    final projects = projectRepo.projects;
    final isLoading = projectRepo.isLoading;

    return Scaffold(
      appBar: AppBar(title: Text('Project Locations')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : projects.isEmpty
              ? Center(child: Text('No project locations available.'))
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(10.8505, 76.2711), // Centered on Kerala
                    zoom: 7.5,
                  ),
                  markers: projects
                      .where((project) => project.location != null)
                      .map(
                        (project) => Marker(
                          markerId: MarkerId(project.id),
                          position: LatLng(
                            project.location!.latitude,
                            project.location!.longitude,
                          ),
                          infoWindow: InfoWindow(
                            title: project.name,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ProjectDetailScreen(project: project),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                      .toSet(),
                ),
    );
  }
}