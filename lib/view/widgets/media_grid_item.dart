import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';

class MediaGridItem extends StatefulWidget {
  final String mediaUrl;
  final bool isImage;

  const MediaGridItem({super.key, required this.mediaUrl, required this.isImage});

  @override
  // ignore: library_private_types_in_public_api
  _MediaGridItemState createState() => _MediaGridItemState();
}

class _MediaGridItemState extends State<MediaGridItem> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;
  bool _videoError = false;
  bool _showControls = false;

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  @override
  void initState() {
    super.initState();
    if (!widget.isImage) {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.mediaUrl),
      );
      _controller
          .initialize()
          .then((_) {
            setState(() {
              _isVideoInitialized = true;
              _controller.setLooping(true);
              _controller.setVolume(0);
              _controller.play();
              _showControls = false;
            });
          })
          .catchError((e) {
            log(e.toString());
            setState(() {
              _videoError = true;
            });
          });
    }
  }

  @override
  void dispose() {
    if (!widget.isImage) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isImage) {
      return CachedNetworkImage(imageUrl: widget.mediaUrl, fit: BoxFit.cover);
    } else if (_videoError) {
      return Center(child: Icon(Icons.error, color: Colors.red));
    } else if (_isVideoInitialized && _controller.value.isInitialized) {
      return GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
            if (!_controller.value.isPlaying || _showControls)
              AnimatedOpacity(
                opacity:
                    (!_controller.value.isPlaying || _showControls) ? 1.0 : 0.0,
                duration: Duration(milliseconds: 200),
                child: Center(
                  child: IconButton(
                    iconSize: 56,
                    icon: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      color: Colors.white,
                      shadows: [Shadow(blurRadius: 8, color: Colors.black45)],
                    ),
                    onPressed: () {
                      setState(() {
                        if (_controller.value.isPlaying) {
                          _controller.pause();
                        } else {
                          _controller.play();
                          _showControls = false;
                        }
                      });
                    },
                  ),
                ),
              ),
          ],
        ),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }
}
