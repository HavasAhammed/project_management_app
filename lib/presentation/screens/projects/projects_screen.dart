import 'package:flutter/material.dart';
import 'package:project_management_app/core/constants/height_and_width.dart';
import 'package:project_management_app/core/theme/app_colors.dart';
import 'package:project_management_app/presentation/widgets/appBar/custom_sub_app_bar.dart';
import 'package:project_management_app/presentation/widgets/loader/circular_loading.dart';
import 'package:project_management_app/presentation/widgets/textField/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:project_management_app/domain/repositories/auth_repository.dart';
import 'package:project_management_app/domain/repositories/project_repository.dart';
import 'package:project_management_app/presentation/screens/charts/charts_screen.dart';
import 'package:project_management_app/presentation/screens/map/map_screen.dart';
import 'package:project_management_app/presentation/screens/projects/project_details_screen.dart';
import 'package:project_management_app/presentation/widgets/project_card.dart';
import 'package:project_management_app/presentation/widgets/dialog/custom_dialog.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<ProjectRepository>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: 'My Projects',
          showBack: false,
          centerTitle: false,
          colors: [Color(0xFF012CA0), Color(0xFF001A63)],
          actions: [
            IconButton(
              icon: Icon(Icons.location_on, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MapScreen()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.bar_chart, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ChartsScreen()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                showCustomDialog(
                  context,
                  title: 'Are You Sure?',
                  message: 'Do you really want to logout your account?',
                  confirmLabel: 'Logout',
                  cancelLabel: 'Cancel',
                  
                  onCompleted: () {
                    context.read<AuthRepository>().logout();
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            CustomTextField(
              controller: null,
              isReset: true,
              labelText: '',
              hintText: 'Search projects...',
              prefixIcon: Icons.search,
              onChanged: (value) {
                context.read<ProjectRepository>().searchProjects(value);
              },
            ),
            kHeight(24),
            Expanded(
              child:
                  repo.isLoading
                      ? loader()
                      : ListView.separated(
                        itemCount: repo.projects.length,
                        separatorBuilder: (context, index) => kHeight(16),
                        itemBuilder: (context, index) {
                          final project = repo.projects[index];
                          return ProjectCard(
                            project: project,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) =>
                                          ProjectDetailScreen(project: project),
                                ),
                              );
                            },
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
