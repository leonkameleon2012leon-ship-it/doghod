import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Widget for displaying dog video animations
class DogVideoWidget extends StatefulWidget {
  const DogVideoWidget({
    super.key,
    required this.videoPath,
    this.size = 160.0,
  });

  final String videoPath;
  final double size;

  @override
  State<DogVideoWidget> createState() => _DogVideoWidgetState();
}

class _DogVideoWidgetState extends State<DogVideoWidget> {
  VideoPlayerController? _controller;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  @override
  void didUpdateWidget(DogVideoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoPath != widget.videoPath) {
      _controller?.dispose();
      _hasError = false;
      _initializeVideo();
    }
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.asset(widget.videoPath);
      await _controller!.initialize();
      if (mounted) {
        setState(() {});
        _controller!.play();
        _controller!.setLooping(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError || _controller == null || !_controller!.value.isInitialized) {
      // Fallback to paw icon if video fails to load
      return Container(
        height: widget.size,
        width: widget.size,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFD8A8), Color(0xFFFFB88C)],
          ),
          borderRadius: BorderRadius.circular(widget.size / 2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFB88C).withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            Icons.pets,
            size: widget.size * 0.56,
            color: const Color(0xFF8D6E63),
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.size / 2),
      child: SizedBox(
        height: widget.size,
        width: widget.size,
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _controller!.value.size.width,
            height: _controller!.value.size.height,
            child: VideoPlayer(_controller!),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
