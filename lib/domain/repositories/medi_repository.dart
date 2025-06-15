import 'dart:io';

import 'package:project_management_app/data/dataresources/media_remote_data_source.dart';

class MediaRepository {
  final MediaRemoteDataSource mediaRemoteDataSource;

  MediaRepository({required this.mediaRemoteDataSource});

  Future<void> uploadMedia(String projectId, File file, String type) async {
    try {
      await mediaRemoteDataSource.uploadMedia(projectId, file, type);
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<String>> getImages(String projectId) {
    return mediaRemoteDataSource.getImages(projectId);
  }

  Stream<List<String>> getVideos(String projectId) {
    return mediaRemoteDataSource.getVideos(projectId);
  }
}