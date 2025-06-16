import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_management_app/core/local/hive_boxes.dart';

class MediaRemoteDataSource {
  Future<void> uploadMedia(String projectId, File file, String type) async {
    try {
      // Ensure Hive is initialized
      if (!Hive.isBoxOpen(HiveBoxes.imagesBox)) {
        final dir = await getApplicationDocumentsDirectory();
        Hive.init(dir.path);
      }
      final boxName =
          type == 'image' ? HiveBoxes.imagesBox : HiveBoxes.videosBox;
      final box = await Hive.openBox<List>(boxName);
      final List<String> currentList =
          box.get(projectId, defaultValue: <String>[])!.cast<String>();
      // Save file locally
      final localDir = await getApplicationDocumentsDirectory();
      final ext = type == 'image' ? 'jpg' : 'mp4';
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$ext';
      final localPath = '${localDir.path}/$fileName';
      final savedFile = await file.copy(localPath);
      currentList.add(savedFile.path);
      await box.put(projectId, currentList);
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<String>> getImages(String projectId) async* {
    final box = await Hive.openBox<List>(HiveBoxes.imagesBox);
    yield box.get(projectId, defaultValue: <String>[])!.cast<String>();
    await for (final _ in box.watch(key: projectId)) {
      yield box.get(projectId, defaultValue: <String>[])!.cast<String>();
    }
  }

  Stream<List<String>> getVideos(String projectId) async* {
    final box = await Hive.openBox<List>(HiveBoxes.videosBox);
    yield box.get(projectId, defaultValue: <String>[])!.cast<String>();
    await for (final _ in box.watch(key: projectId)) {
      yield box.get(projectId, defaultValue: <String>[])!.cast<String>();
    }
  }
}
