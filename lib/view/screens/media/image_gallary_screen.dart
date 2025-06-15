import 'package:flutter/material.dart';
import 'package:project_management_app/domain/repositories/medi_repository.dart';
import 'package:project_management_app/view/screens/media/media_upload_screen.dart';
import 'package:project_management_app/view/widgets/media_grid_item.dart';
import 'package:provider/provider.dart';

class ImageGalleryScreen extends StatelessWidget {
  final String projectId;

  const ImageGalleryScreen({required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      MediaUploadScreen(projectId: projectId, isImage: true),
            ),
          );
        },
      ),
      body: StreamBuilder<List<String>>(
        stream: context.read<MediaRepository>().getImages(projectId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return MediaGridItem(
                  mediaUrl: snapshot.data![index],
                  isImage: true,
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
