import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_management_app/view/screens/media/media_upload_screen.dart';
import 'package:project_management_app/view/widgets/media_grid_item.dart';

class VideoGalleryScreen extends StatelessWidget {
  final String projectId;

  const VideoGalleryScreen({super.key, required this.projectId});

  Future<List<String>> fetchVideoUrls(String projectId) async {
    final doc =
        await FirebaseFirestore.instance
            .collection('projects')
            .doc(projectId)
            .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      final videoUrls = List<String>.from(data['videoUrls'] ?? []);
      return videoUrls;
    }
    return [];
  }

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
                      MediaUploadScreen(projectId: projectId, isImage: false),
            ),
          );
        },
      ),
      body: FutureBuilder<List<String>>(
        future: fetchVideoUrls(projectId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
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
