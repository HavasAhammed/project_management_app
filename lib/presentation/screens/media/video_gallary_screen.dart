import 'package:flutter/material.dart';
import 'package:project_management_app/domain/repositories/medi_repository.dart';
import 'package:provider/provider.dart';
import 'package:project_management_app/core/theme/app_colors.dart';
import 'package:project_management_app/presentation/screens/media/media_upload_screen.dart';
import 'package:project_management_app/presentation/widgets/loader/circular_loading.dart';
import 'package:project_management_app/presentation/widgets/media_grid_item.dart';

class VideoGalleryScreen extends StatelessWidget {
  final String projectId;

  const VideoGalleryScreen({super.key, required this.projectId});

  // No longer needed: fetchVideoUrls

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryBlueColor,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      MediaUploadScreen(projectId: projectId, isImage: false),
            ),
          );
        },
        child: Icon(Icons.add, color: AppColors.whiteColor, size: 28),
      ),
      body: StreamBuilder<List<String>>(
        stream: Provider.of<MediaRepository>(
          context,
          listen: false,
        ).getVideos(projectId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loader();
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error fetching videos'));
          }
          final videoUrls = snapshot.data ?? [];
          if (videoUrls.isEmpty) {
            return Center(child: Text('No videos available'));
          }

          return GridView.builder(
            padding: EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: videoUrls.length,
            itemBuilder: (context, index) {
              return MediaGridItem(mediaUrl: videoUrls[index], isImage: false);
            },
          );
        },
      ),
    );
  }
}
