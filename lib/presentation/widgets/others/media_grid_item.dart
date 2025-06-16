import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gal/gal.dart';
import 'package:project_management_app/presentation/widgets/snackBar/custom_snack_bar.dart';
import 'package:video_player/video_player.dart';
import 'package:project_management_app/presentation/widgets/loader/shimmer_loader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';

class MediaGridItem extends StatefulWidget {
  final String mediaUrl;
  final bool isImage;

  const MediaGridItem({
    super.key,
    required this.mediaUrl,
    required this.isImage,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MediaGridItemState createState() => _MediaGridItemState();
}

class _MediaGridItemState extends State<MediaGridItem> {
  Future<void> _downloadMedia() async {
    try {
      final isLocalFile =
          widget.mediaUrl.startsWith('/') ||
          widget.mediaUrl.startsWith('file://');
      await _askPermission();

      if (widget.isImage) {
        if (isLocalFile) {
          await Gal.putImage(widget.mediaUrl); // ✅ pass path directly
        } else {
          final response = await Dio().get(
            widget.mediaUrl,
            options: Options(responseType: ResponseType.bytes),
          );
          final tempDir = await Directory.systemTemp.createTemp();
          final fileName = widget.mediaUrl.split('/').last;
          final tempFile = File('${tempDir.path}/$fileName');
          await tempFile.writeAsBytes(response.data);
          await Gal.putImage(tempFile.path); // ✅ path, not File
        }
      } else {
        if (isLocalFile) {
          await Gal.putVideo(widget.mediaUrl);
        } else {
          final response = await Dio().get(
            widget.mediaUrl,
            options: Options(responseType: ResponseType.bytes),
          );
          final tempDir = await Directory.systemTemp.createTemp();
          final fileName = widget.mediaUrl.split('/').last;
          final tempFile = File('${tempDir.path}/$fileName');
          await tempFile.writeAsBytes(response.data);
          await Gal.putVideo(tempFile.path);
        }
      }

      CustomSnackBar.show(
        context: context,
        message: 'Saved to gallery!',
        isSuccess: true,
      );
    } catch (e) {
      CustomSnackBar.show(
        context: context,
        message: 'Save failed: $e',
        isSuccess: false,
      );
    }
  }

  Future<void> _askPermission() async {
    if (Platform.isIOS) {
      await [Permission.photos].request();
    } else if (Platform.isAndroid) {
      await [Permission.storage].request();
    }
  }

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
      _controller =
          widget.mediaUrl.startsWith('/') ||
                  widget.mediaUrl.startsWith('file://')
              ? VideoPlayerController.file(File(widget.mediaUrl))
              : VideoPlayerController.networkUrl(Uri.parse(widget.mediaUrl));
      _controller
          .initialize()
          .then((_) {
            setState(() {
              _isVideoInitialized = true;
              _controller.setLooping(true);
              _controller.setVolume(1.0); // Enable audio
              // Do not auto-play
              _showControls = true; // Show play button overlay by default
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
    final downloadButton = Positioned(
      top: 8,
      right: 8,
      child: Material(
        color: Colors.black.withOpacity(0.3),
        shape: const CircleBorder(),
        child: IconButton(
          icon: const Icon(
            Icons.download,
            color: Colors.white,
            size: 20,
          ), // smaller icon
          onPressed: _downloadMedia,
          tooltip: 'Download',
          constraints: const BoxConstraints(
            minWidth: 30,
            minHeight: 30,
          ), // smaller touch target
          padding: EdgeInsets.zero, // tight padding
        ),
      ),
    );
    const borderRadius = BorderRadius.all(Radius.circular(8));
    if (widget.isImage) {
      final isLocalFile =
          widget.mediaUrl.startsWith('/') ||
          widget.mediaUrl.startsWith('file://');
      if (isLocalFile) {
        return ClipRRect(
          borderRadius: borderRadius,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.file(
                File(widget.mediaUrl),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder:
                    (context, error, stackTrace) =>
                        const Icon(Icons.error, color: Colors.red),
                gaplessPlayback: true,
              ),
              downloadButton,
            ],
          ),
        );
      } else {
        return ClipRRect(
          borderRadius: borderRadius,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: widget.mediaUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                placeholder:
                    (context, url) => const ShimmerLoader(
                      width: double.infinity,
                      height: double.infinity,
                      borderRadius: borderRadius,
                    ),
                errorWidget:
                    (context, url, error) =>
                        const Icon(Icons.error, color: Colors.red),
              ),
              downloadButton,
            ],
          ),
        );
      }
    } else if (_videoError) {
      return const SizedBox.expand(
        child: Center(child: Icon(Icons.error, color: Colors.red)),
      );
    } else if (_isVideoInitialized && _controller.value.isInitialized) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              onTap: _toggleControls,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller.value.size.width,
                        height: _controller.value.size.height,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  ),
                  if (!_controller.value.isPlaying || _showControls)
                    AnimatedOpacity(
                      opacity:
                          (!_controller.value.isPlaying || _showControls)
                              ? 1.0
                              : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Center(
                        child: IconButton(
                          iconSize: 56,
                          icon: Icon(
                            _controller.value.isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_filled,
                            color: Colors.white,
                            shadows: [
                              Shadow(blurRadius: 8, color: Colors.black45),
                            ],
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
            ),
            downloadButton,
          ],
        ),
      );
    } else {
      return const ShimmerLoader(
        width: double.infinity,
        height: double.infinity,
        borderRadius: borderRadius,
      );
    }
  }
}
