import 'dart:async';
import 'package:flutter/material.dart';

/// Page to show full album as a slideshow with lazy loading.
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

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // Pre-load first few images
    _preloadNearbyImages(0);
    // Start auto-play
    _startAutoPlay();
  }

  /// Preload images near current index (±3 images)
  void _preloadNearbyImages(int index) {
    final start = (index - 3).clamp(0, widget.imagePaths.length - 1);
    final end = (index + 3).clamp(0, widget.imagePaths.length - 1);
    
    for (int i = start; i <= end; i++) {
      if (!_loadedImages.contains(i)) {
        _loadedImages.add(i);
      }
    }
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    if (widget.imagePaths.length <= 1 || !_isAutoPlaying) return;
    
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
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

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          final shouldLoad = _loadedImages.contains(index) ||
              (index - _currentIndex).abs() <= 3;

          if (!shouldLoad) {
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
                // Higher quality - no cacheWidth limit for sharp images
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
                          Icon(Icons.broken_image, color: Colors.white54, size: 48),
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
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _FullscreenImagePage(
          imagePath: widget.imagePaths[index],
        ),
      ),
    ).then((_) {
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 5.0,
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain,
            // Full resolution for zooming
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(Icons.broken_image, color: Colors.white54, size: 64),
              );
            },
          ),
        ),
      ),
    );
  }
}
