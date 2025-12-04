import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Page to show full album as a slideshow with lazy loading.
/// Optimized for mobile web performance.
class AlbumSlideshowPage extends StatefulWidget {
  const AlbumSlideshowPage({super.key, required this.imagePaths});

  final List<String> imagePaths;

  @override
  State<AlbumSlideshowPage> createState() => _AlbumSlideshowPageState();
}

class _AlbumSlideshowPageState extends State<AlbumSlideshowPage> {
  late final PageController _pageController;
  Timer? _autoPlayTimer;
  int _currentIndex = 0;
  bool _isAutoPlaying = true; // Auto-play enabled by default

  // Track which images are loaded
  final Set<int> _loadedImages = {};

  // Track screen size for cache optimization
  Size? _screenSize;
  bool _isMobile = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // Pre-load first few images
    _preloadNearbyImages(0);
    // Start auto-play
    _startAutoPlay();
  }

  /// Determine if device is mobile based on screen width
  bool _checkIsMobile(Size screenSize) {
    return screenSize.width < 600;
  }

  /// Get preload range based on device type (mobile: ±1, desktop: ±2)
  int _getPreloadRange() {
    return _isMobile ? 1 : 2;
  }

  /// Preload images near current index (optimized for mobile)
  void _preloadNearbyImages(int index) {
    final range = _getPreloadRange();
    final start = (index - range).clamp(0, widget.imagePaths.length - 1);
    final end = (index + range).clamp(0, widget.imagePaths.length - 1);

    for (int i = start; i <= end; i++) {
      if (!_loadedImages.contains(i)) {
        _loadedImages.add(i);
      }
    }

    // Unload images that are too far away to free memory (especially important for mobile)
    _unloadDistantImages(index);
  }

  /// Unload images that are far from current index to free memory
  void _unloadDistantImages(int currentIndex) {
    final unloadThreshold = _isMobile ? 3 : 5; // More aggressive on mobile
    final toRemove = <int>[];

    for (final loadedIndex in _loadedImages) {
      if ((loadedIndex - currentIndex).abs() > unloadThreshold) {
        toRemove.add(loadedIndex);
      }
    }

    for (final index in toRemove) {
      _loadedImages.remove(index);
    }
  }

  /// Calculate optimal cache width for images based on screen size
  int? _getCacheWidth(Size screenSize) {
    // Only optimize for mobile web to prevent memory issues
    if (!kIsWeb || !_isMobile) {
      // Desktop web or native: use full resolution
      return null;
    }

    // Mobile web: limit to 2x screen width for better performance
    // This significantly reduces memory usage (from ~5MB to ~500KB per image)
    final maxWidth = (screenSize.width * 2).round();
    // Cap at 1920px to avoid loading huge images
    return maxWidth.clamp(800, 1920);
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    if (widget.imagePaths.length <= 1 || !_isAutoPlaying) return;

    _autoPlayTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (!mounted || !_isAutoPlaying) return;
      final nextIndex = (_currentIndex + 1) % widget.imagePaths.length;
      _pageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void _toggleAutoPlay() {
    setState(() {
      _isAutoPlaying = !_isAutoPlaying;
    });
    if (_isAutoPlaying) {
      _startAutoPlay();
    } else {
      _autoPlayTimer?.cancel();
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Lazy load nearby images when page changes
    _preloadNearbyImages(index);
  }

  /// Check if image should be loaded based on distance from current index
  bool _shouldLoadImage(int index) {
    final range = _getPreloadRange();
    return _loadedImages.contains(index) ||
        (index - _currentIndex).abs() <= range;
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Update screen size and mobile detection
    final screenSize = MediaQuery.of(context).size;
    if (_screenSize != screenSize) {
      _screenSize = screenSize;
      _isMobile = _checkIsMobile(screenSize);
    }

    // Calculate cache width for mobile web optimization
    final cacheWidth = _getCacheWidth(screenSize);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('${_currentIndex + 1} / ${widget.imagePaths.length}'),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          // Auto-play toggle
          IconButton(
            icon: Icon(
              _isAutoPlaying ? Icons.pause_circle : Icons.play_circle,
              size: 28,
            ),
            onPressed: _toggleAutoPlay,
            tooltip: _isAutoPlaying ? 'Dừng tự động' : 'Tự động chạy',
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.imagePaths.length,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          // Only build image if it's near current position
          if (!_shouldLoadImage(index)) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white54),
            );
          }

          return GestureDetector(
            onTap: () => _openFullscreen(index),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Image.asset(
                widget.imagePaths[index],
                fit: BoxFit.contain,
                // Optimize memory usage on mobile web with cacheWidth
                cacheWidth: cacheWidth,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded || frame != null) {
                    return child;
                  }
                  return Container(
                    color: Colors.grey[900],
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white54,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[900],
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.broken_image,
                            color: Colors.white54,
                            size: 48,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Không tải được ảnh',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      // Bottom navigation
      bottomNavigationBar: Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Previous button
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: _currentIndex > 0
                  ? () {
                      _autoPlayTimer?.cancel();
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                      if (_isAutoPlaying) _startAutoPlay();
                    }
                  : null,
            ),
            const SizedBox(width: 40),
            // Next button
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
              onPressed: _currentIndex < widget.imagePaths.length - 1
                  ? () {
                      _autoPlayTimer?.cancel();
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                      if (_isAutoPlaying) _startAutoPlay();
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  void _openFullscreen(int index) {
    // Pause auto-play when viewing fullscreen
    _autoPlayTimer?.cancel();

    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) =>
                _FullscreenImagePage(imagePath: widget.imagePaths[index]),
          ),
        )
        .then((_) {
          // Resume auto-play when returning
          if (_isAutoPlaying) _startAutoPlay();
        });
  }
}

/// Fullscreen view with zoom
class _FullscreenImagePage extends StatelessWidget {
  const _FullscreenImagePage({required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 600 || kIsWeb;

    // For fullscreen zoom, still use cacheWidth on mobile web to prevent crashes
    // but allow higher resolution for zooming
    final cacheWidth = (kIsWeb && isMobile)
        ? (screenSize.width * 3).round().clamp(1200, 2560)
        : null;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      extendBodyBehindAppBar: true,
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 5.0,
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain,
            // Higher resolution for zooming, but still optimized for mobile web
            cacheWidth: cacheWidth,
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(
                  Icons.broken_image,
                  color: Colors.white54,
                  size: 64,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
