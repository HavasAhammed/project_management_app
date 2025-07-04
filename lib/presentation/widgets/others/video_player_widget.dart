import 'package:flutter/material.dart';
import 'package:project_management_app/presentation/widgets/loader/circular_loading.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class VideoPlayerWidget extends StatefulWidget {
  final File file;

  const VideoPlayerWidget({super.key, required this.file});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.file)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
        : loader();
  }
}
