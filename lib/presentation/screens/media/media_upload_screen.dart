import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:project_management_app/domain/repositories/medi_repository.dart';
import 'package:project_management_app/presentation/widgets/video_player_widget.dart';
import 'package:provider/provider.dart';

class MediaUploadScreen extends StatefulWidget {
  final String projectId;
  final bool isImage;

  const MediaUploadScreen({required this.projectId, required this.isImage});

  @override
  _MediaUploadScreenState createState() => _MediaUploadScreenState();
}

class _MediaUploadScreenState extends State<MediaUploadScreen> {
  File? _selectedFile;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: widget.isImage ? FileType.image : FileType.video,
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedFile != null) {
      await context.read<MediaRepository>().uploadMedia(
        widget.projectId,
        _selectedFile!,
        widget.isImage ? 'image' : 'video',
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Media')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              widget.isImage ? 'Upload Image' : 'Upload Video',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            if (_selectedFile != null)
              widget.isImage
                  ? Image.file(_selectedFile!, height: 200)
                  : VideoPlayerWidget(file: _selectedFile!),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _pickFile, child: Text('Select File')),
            SizedBox(height: 20),
            if (_selectedFile != null)
              ElevatedButton(onPressed: _uploadFile, child: Text('Upload')),
          ],
        ),
      ),
    );
  }
}
