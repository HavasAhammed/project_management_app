import 'package:flutter/material.dart';
import 'package:project_management_app/core/utils/utils.dart';
import 'package:project_management_app/domain/models/project_model.dart';
import 'package:project_management_app/presentation/screens/media/image_gallary_screen.dart';
import 'package:project_management_app/presentation/screens/media/video_gallary_screen.dart';
import 'package:project_management_app/core/theme/app_colors.dart';
import 'package:project_management_app/presentation/widgets/appBar/custom_sub_app_bar.dart';

class ProjectDetailScreen extends StatelessWidget {
  final Project project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 74),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF012CA0), Color(0xFF001A63)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomAppBar(
                  title: Utils.capitalizeWords(project.name),
                  showBack: true,
                  centerTitle: false,
                  colors: [Color(0xFF012CA0), Color(0xFF001A63)],
                ),
                Container(
                  color: AppColors.whiteColor,
                  child: TabBar(
                    labelColor: const Color(0xFF012CA0),
                    unselectedLabelColor: Colors.black54,
                    indicator: UnderlineTabIndicator(
                      borderSide: const BorderSide(
                        width: 4.0,
                        color: Color(0xFF012CA0),
                      ),
                      insets: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.3,
                      ),
                    ),
                    tabs: const [
                      Tab(icon: Icon(Icons.image), text: 'Images'),
                      Tab(icon: Icon(Icons.video_library), text: 'Videos'),
                    ],
                  ),
                ),
              ],
            ),
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
