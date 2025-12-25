import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Custom cache manager for video files
/// Provides efficient caching with configurable storage limits
class VideoCacheManager {
  static const key = 'fitpilot_exercise_videos';
  static VideoCacheManager? _instance;

  static VideoCacheManager get instance {
    _instance ??= VideoCacheManager._();
    return _instance!;
  }

  late final CacheManager _cacheManager;

  VideoCacheManager._() {
    _cacheManager = CacheManager(
      Config(
        key,
        stalePeriod: const Duration(days: 30), // Cache videos for 30 days
        maxNrOfCacheObjects: 100, // Store up to 100 videos
        repo: JsonCacheInfoRepository(databaseName: key),
        fileService: HttpFileService(),
      ),
    );
    debugPrint('FITPILOT CACHE: Cache manager initialized with key: $key');
  }

  /// Normalize S3 pre-signed URL to a stable cache key
  /// Extracts the object path without query parameters (AWS signatures)
  String _normalizeCacheKey(String url) {
    try {
      final uri = Uri.parse(url);
      // Use the path (e.g., /exercises/squat_instruction.mp4) as the cache key
      // This ensures the same file is cached even with different AWS signatures
      final cacheKey = '${uri.host}${uri.path}';
      debugPrint('FITPILOT CACHE: Normalized URL to cache key: $cacheKey');
      return cacheKey;
    } catch (e) {
      debugPrint('FITPILOT CACHE: Error normalizing URL, using original: $e');
      return url;
    }
  }

  /// Get a cached video file or download it if not available
  /// Returns a File object that can be used with VideoPlayerController.file()
  Future<File> getCachedVideo(String url) async {
    debugPrint('FITPILOT CACHE: Getting video for URL: $url');

    final cacheKey = _normalizeCacheKey(url);
    final fileInfo = await _cacheManager.getFileFromCache(cacheKey);

    if (fileInfo != null && fileInfo.file.existsSync()) {
      // Video is cached, return the file
      debugPrint('FITPILOT CACHE: Video found in cache, returning existing file');
      return fileInfo.file;
    }

    // Video is not cached, download and cache it
    debugPrint('FITPILOT CACHE: Video not in cache, downloading...');
    final file = await _cacheManager.getSingleFile(url, key: cacheKey);
    final size = await file.length();
    final sizeMB = (size / (1024 * 1024)).toStringAsFixed(2);
    debugPrint('FITPILOT CACHE: Video downloaded and cached successfully ($sizeMB MB)');
    debugPrint('FITPILOT CACHE: File saved to: ${file.path}');

    // Verify it was actually cached
    final verifyInfo = await _cacheManager.getFileFromCache(cacheKey);
    debugPrint('FITPILOT CACHE: Verification - Is now cached: ${verifyInfo != null}');

    return file;
  }

  /// Get a stream of file download info for showing progress
  Stream<FileResponse> getCachedVideoStream(String url) {
    final cacheKey = _normalizeCacheKey(url);
    return _cacheManager.getFileStream(url, key: cacheKey);
  }

  /// Check if a video is already cached
  Future<bool> isVideoCached(String url) async {
    try {
      debugPrint('FITPILOT CACHE: Checking cache for URL: $url');
      final cacheKey = _normalizeCacheKey(url);
      final fileInfo = await _cacheManager.getFileFromCache(cacheKey);

      if (fileInfo == null) {
        debugPrint('FITPILOT CACHE: No cache entry found for this URL');
        return false;
      }

      final exists = fileInfo.file.existsSync();
      debugPrint('FITPILOT CACHE: Cache entry found, file exists: $exists');

      if (exists) {
        final size = await fileInfo.file.length();
        final sizeMB = (size / (1024 * 1024)).toStringAsFixed(2);
        debugPrint('FITPILOT CACHE: Cached file path: ${fileInfo.file.path}');
        debugPrint('FITPILOT CACHE: Cached file size: $sizeMB MB');
      }

      return exists;
    } catch (e) {
      debugPrint('FITPILOT CACHE: Error checking cache - $e');
      return false;
    }
  }

  /// Get the cached file if it exists, without downloading
  Future<File?> getCachedVideoFile(String url) async {
    try {
      final cacheKey = _normalizeCacheKey(url);
      final fileInfo = await _cacheManager.getFileFromCache(cacheKey);
      if (fileInfo != null && fileInfo.file.existsSync()) {
        debugPrint('FITPILOT CACHE: Returning cached file from disk');
        return fileInfo.file;
      }
      debugPrint('FITPILOT CACHE: No cached file found on disk');
      return null;
    } catch (e) {
      debugPrint('FITPILOT CACHE: Error getting cached file - $e');
      return null;
    }
  }

  /// Remove a specific video from cache
  Future<void> removeVideo(String url) async {
    final cacheKey = _normalizeCacheKey(url);
    await _cacheManager.removeFile(cacheKey);
  }

  /// Clear all cached videos
  Future<void> clearCache() async {
    await _cacheManager.emptyCache();
  }

  /// Get cache size information
  Future<Map<String, dynamic>> getCacheInfo() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      debugPrint('FITPILOT CACHE: Cache base directory: ${cacheDir.path}');

      final videoCacheDir = Directory(path.join(cacheDir.path, key));
      debugPrint('FITPILOT CACHE: Video cache directory: ${videoCacheDir.path}');

      if (!videoCacheDir.existsSync()) {
        debugPrint('FITPILOT CACHE: Cache directory does not exist yet');
        return {'fileCount': 0, 'totalSize': 0, 'totalSizeMB': '0.00'};
      }

      int fileCount = 0;
      int totalSize = 0;

      await for (final entity in videoCacheDir.list(recursive: true)) {
        if (entity is File) {
          fileCount++;
          final size = await entity.length();
          totalSize += size;
          debugPrint('FITPILOT CACHE: Found cached file: ${entity.path} (${(size / (1024 * 1024)).toStringAsFixed(2)} MB)');
        }
      }

      debugPrint('FITPILOT CACHE: Total files: $fileCount, Total size: ${(totalSize / (1024 * 1024)).toStringAsFixed(2)} MB');

      return {
        'fileCount': fileCount,
        'totalSize': totalSize,
        'totalSizeMB': (totalSize / (1024 * 1024)).toStringAsFixed(2),
      };
    } catch (e) {
      debugPrint('FITPILOT CACHE: Error getting cache info - $e');
      return {'fileCount': 0, 'totalSize': 0, 'totalSizeMB': '0.00'};
    }
  }
}
