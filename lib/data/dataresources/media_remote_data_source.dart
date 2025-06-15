import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MediaRemoteDataSource {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadMedia(String projectId, File file, String type) async {
    try {
      // Upload file to storage
      final ref = _storage.ref().child('$projectId/$type/${DateTime.now()}.${type == 'image' ? 'jpg' : 'mp4'}');
      await ref.putFile(file);

      // Get download URL
      final url = await ref.getDownloadURL();

      // Update Firestore document
      await _firestore.collection('projects').doc(projectId).update({
        '${type}Urls': FieldValue.arrayUnion([url]),
      });
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<String>> getImages(String projectId) {
    return _firestore.collection('projects').doc(projectId).snapshots().map(
      (snapshot) {
        final data = snapshot.data();
        return data != null ? List<String>.from(data['imageUrls'] ?? []) : [];
      },
    );
  }

  Stream<List<String>> getVideos(String projectId) {
    return _firestore.collection('projects').doc(projectId).snapshots().map(
      (snapshot) {
        final data = snapshot.data();
        return data != null ? List<String>.from(data['videoUrls'] ?? []) : [];
      },
    );
  }
}