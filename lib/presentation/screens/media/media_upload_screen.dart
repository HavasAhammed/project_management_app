import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:project_management_app/domain/repositories/medi_repository.dart';
import 'package:project_management_app/presentation/widgets/video_player_widget.dart';
import 'package:project_management_app/presentation/widgets/button/primary_button.dart';
import 'package:project_management_app/presentation/widgets/appBar/custom_sub_app_bar.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

class MediaUploadScreen extends StatefulWidget {
  final String projectId;
  final bool isImage;

  const MediaUploadScreen({
    super.key,
    required this.projectId,
    required this.isImage,
  });

  @override
  _MediaUploadScreenState createState() => _MediaUploadScreenState();
}

class _MediaUploadScreenState extends State<MediaUploadScreen> {
  File? _selectedFile;
  bool _isUploading = false;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: widget.isImage ? FileType.image : FileType.video,
    );
    if (result != null && result.files.single.path != null) {
      // Copy file to app's local directory for consistency
      final appDir = await getApplicationDocumentsDirectory();
      final ext = widget.isImage ? 'jpg' : 'mp4';
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$ext';
      final localPath = p.join(appDir.path, fileName);
      final pickedFile = File(result.files.single.path!);
      final savedFile = await pickedFile.copy(localPath);
      setState(() {
        _selectedFile = savedFile;
      });
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedFile != null) {
      setState(() {
        _isUploading = true;
      });
      try {
        await context.read<MediaRepository>().uploadMedia(
          widget.projectId,
          _selectedFile!,
          widget.isImage ? 'image' : 'video',
        );
        if (mounted) Navigator.pop(context);
      } finally {
        if (mounted) {
          setState(() {
            _isUploading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: 'Upload ${widget.isImage ? 'Image' : 'Video'}',
          showBack: true,
          centerTitle: true,
          colors: const [Color(0xFF012CA0), Color(0xFF001A63)],
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F4FB),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    widget.isImage ? Icons.image : Icons.videocam,
                    color: const Color(0xFF012CA0),
                    size: 40,
                  ),
                ),
                const SizedBox(height: 24),
                if (_selectedFile != null)
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child:
                            widget.isImage
                                ? Image.file(
                                  _selectedFile!,
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                )
                                : SizedBox(
                                  width: double.infinity,
                                  height: 180,
                                  child: VideoPlayerWidget(
                                    file: _selectedFile!,
                                  ),
                                ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedFile = null;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                if (_selectedFile == null)
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Color(0xFFE0E0E0)),
                    ),
                    child: Center(
                      child: Text(
                        'No file selected',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ),
                  ),
                const SizedBox(height: 32),
                PrimaryButton(
                  label: 'Select File',
                  width: MediaQuery.of(context).size.width / 1.5,
                  onPressed: _pickFile,
                  buttonColor: const Color(0xFF012CA0),
                  labelColor: Colors.white,
                  height: 48,
                  icon: const Icon(Icons.upload_file, color: Colors.white),
                ),
                const SizedBox(height: 16),
                if (_selectedFile != null)
                  PrimaryButton(
                    label: _isUploading ? 'Uploading...' : 'Upload',
                    width: MediaQuery.of(context).size.width / 1.5,
                    onPressed: _isUploading ? null : _uploadFile,
                    buttonColor: const Color(0xFF30AE4A),
                    labelColor: Colors.white,
                    height: 48,
                    // icon: const Icon(Icons.cloud_upload, color: Colors.white),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
