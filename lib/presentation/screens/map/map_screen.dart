import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:project_management_app/core/theme/app_colors.dart';
import 'package:project_management_app/domain/models/project_model.dart';
import 'package:project_management_app/presentation/screens/projects/project_details_screen.dart';
import 'package:project_management_app/presentation/widgets/appBar/custom_sub_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:project_management_app/domain/repositories/project_repository.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final projectRepo = context.watch<ProjectRepository>();
    final List<Project> projects = projectRepo.projects;
    final bool isLoading = projectRepo.isLoading;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(title: 'Project Locations'),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : projects.isEmpty
              ? const Center(child: Text('No project locations available.'))
              : FlutterMap(
                options: MapOptions(
                  center: LatLng(10.8505, 76.2711), // Kerala
                  zoom: 7.5,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.project_management_app',
                  ),
                  MarkerLayer(
                    markers:
                        projects
                            .where((p) => p.location != null)
                            .map(
                              (project) => Marker(
                                width: 80.0,
                                height: 80.0,
                                point: LatLng(
                                  project.location!.latitude,
                                  project.location!.longitude,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => ProjectDetailScreen(
                                              project: project,
                                            ),
                                      ),
                                    );
                                  },
                                  child: Tooltip(
                                    message: project.name,
                                    child: const Icon(
                                      Icons.location_on,
                                      size: 40,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ],
              ),
    );
  }
}
