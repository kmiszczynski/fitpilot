import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../core/cache/video_cache_manager.dart';

class ExerciseVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const ExerciseVideoPlayer({
    super.key,
    required this.videoUrl,
  });

  @override
  State<ExerciseVideoPlayer> createState() => _ExerciseVideoPlayerState();
}

class _ExerciseVideoPlayerState extends State<ExerciseVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  String? _errorMessage;
  bool _isCached = false;
  double _downloadProgress = 0.0;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      // Check if video is already cached
      final isCached = await VideoCacheManager.instance.isVideoCached(widget.videoUrl);
      debugPrint('═══════════════════════════════════════════════════');
      debugPrint('FITPILOT VIDEO: Cache check result: ${isCached ? "✅ CACHED" : "❌ NOT CACHED"}');
      debugPrint('═══════════════════════════════════════════════════');

      if (isCached) {
        // Use cached video - no downloading needed
        if (mounted) {
          setState(() {
            _isCached = true;
            _isDownloading = false;
          });
        }

        debugPrint('FITPILOT VIDEO: Loading from cache (no network needed)');
        final cachedFile = await VideoCacheManager.instance.getCachedVideoFile(widget.videoUrl);
        if (cachedFile != null) {
          debugPrint('FITPILOT VIDEO: ✅ SUCCESS - Video loaded from cache');
          await _initializeFromFile(cachedFile);
          return;
        }
      }

      // Video not cached, download and cache it
      debugPrint('FITPILOT VIDEO: ⬇️ DOWNLOADING from network (first time)...');
      if (mounted) {
        setState(() {
          _isDownloading = true;
          _isCached = false;
        });
      }

      final cachedFile = await VideoCacheManager.instance.getCachedVideo(widget.videoUrl);
      debugPrint('FITPILOT VIDEO: ✅ SUCCESS - Downloaded and cached');

      await _initializeFromFile(cachedFile);

      if (mounted) {
        setState(() {
          _isDownloading = false;
          _isCached = true;
        });
      }
    } catch (e) {
      debugPrint('FITPILOT VIDEO: ❌ ERROR - $e');
      if (!mounted) return;

      setState(() {
        _hasError = true;
        _isDownloading = false;
        _errorMessage = 'Failed to load video: ${e.toString()}';
      });
    }
  }

  Future<void> _initializeFromFile(File file) async {
    _controller = VideoPlayerController.file(file);
    await _controller.initialize();

    if (!mounted) return;

    setState(() {
      _isInitialized = true;
    });

    // Set video to loop
    _controller.setLooping(true);

    // Auto-play the video
    _controller.play();

    // Listen to player state changes
    _controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.03),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.error.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.videocam_off_outlined,
                    color: Theme.of(context).colorScheme.error.withOpacity(0.6),
                    size: 40,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Video unavailable',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.error.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (!_isInitialized) {
      return AspectRatio(
        aspectRatio: 16 / 9, // Standard video aspect ratio
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: _togglePlayPause,
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(_controller),

            // Play/Pause overlay
            if (!_controller.value.isPlaying)
              Container(
                color: Colors.black26,
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 80,
                ),
              ),

            // Video controls at the bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      // Play/Pause button
                      IconButton(
                        icon: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                        ),
                        onPressed: _togglePlayPause,
                      ),

                      // Current time
                      Text(
                        _formatDuration(_controller.value.position),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),

                      // Progress bar
                      Expanded(
                        child: Slider(
                          value: _controller.value.position.inMilliseconds
                              .toDouble(),
                          min: 0,
                          max: _controller.value.duration.inMilliseconds
                              .toDouble(),
                          onChanged: (value) {
                            _controller.seekTo(
                              Duration(milliseconds: value.toInt()),
                            );
                          },
                          activeColor: Theme.of(context).colorScheme.primary,
                          inactiveColor: Colors.white38,
                        ),
                      ),

                      // Total duration
                      Text(
                        _formatDuration(_controller.value.duration),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),

                      // Mute/Unmute button
                      IconButton(
                        icon: Icon(
                          _controller.value.volume > 0
                              ? Icons.volume_up
                              : Icons.volume_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _controller.setVolume(
                              _controller.value.volume > 0 ? 0 : 1,
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}