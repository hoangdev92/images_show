import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Page to show full album as a slideshow with lazy loading.
/// Optimized for mobile and web performance.
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
  bool _isAutoPlaying = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    if (widget.imagePaths.length <= 1 || !_isAutoPlaying) return;
    
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted || !_isAutoPlaying) return;
      final nextIndex = (_currentIndex + 1) % widget.imagePaths.length;
      _pageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void _stopAutoPlay() {
    _autoPlayTimer?.cancel();
    setState(() => _isAutoPlaying = false);
  }

  void _resumeAutoPlay() {
    setState(() => _isAutoPlaying = true);
    _startAutoPlay();
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 600;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Album (${widget.imagePaths.length} ảnh)'),
        backgroundColor: Colors.black,
        actions: [
          // Toggle auto-play button
          IconButton(
            icon: Icon(_isAutoPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: _isAutoPlaying ? _stopAutoPlay : _resumeAutoPlay,
            tooltip: _isAutoPlaying ? 'Dừng tự động' : 'Tự động chạy',
          ),
        ],
      ),
      body: Column(
        children: [
          // Image counter
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${_currentIndex + 1} / ${widget.imagePaths.length}',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
          // Image slideshow
          Expanded(
            child: GestureDetector(
              onPanDown: (_) => _stopAutoPlay(),
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.imagePaths.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (context, index) {
                  return _ImageCard(
                    imagePath: widget.imagePaths[index],
                    index: index,
                    isMobile: isMobile,
                    pageController: _pageController,
                  );
                },
              ),
            ),
          ),
          // Thumbnail strip (only show on larger screens)
          if (!isMobile && widget.imagePaths.length <= 50)
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.imagePaths.length,
                itemBuilder: (context, index) {
                  final isSelected = index == _currentIndex;
                  return GestureDetector(
                    onTap: () {
                      _stopAutoPlay();
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      width: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? Colors.white : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.asset(
                          widget.imagePaths[index],
                          fit: BoxFit.cover,
                          cacheWidth: 100,
                          cacheHeight: 100,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

/// Optimized image card with lazy loading and error handling
class _ImageCard extends StatelessWidget {
  final String imagePath;
  final int index;
  final bool isMobile;
  final PageController pageController;

  const _ImageCard({
    required this.imagePath,
    required this.index,
    required this.isMobile,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pageController,
      builder: (context, child) {
        double scale = 1.0;
        if (pageController.position.haveDimensions) {
          final currentPage = pageController.page ?? pageController.initialPage.toDouble();
          final diff = (currentPage - index).abs();
          scale = (1 - (diff * 0.15)).clamp(0.85, 1.0);
        }
        return Center(
          child: Transform.scale(scale: scale, child: child),
        );
      },
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => FullscreenImagePage(
                imagePath: imagePath,
                heroTag: 'album-image-$index',
              ),
            ),
          );
        },
        child: Hero(
          tag: 'album-image-$index',
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                // Reduce image size for performance
                cacheWidth: kIsWeb || isMobile ? 600 : 1000,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) return child;
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: frame != null
                        ? child
                        : Container(
                            color: Colors.grey[900],
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white54,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[900],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.broken_image, color: Colors.white54, size: 48),
                        const SizedBox(height: 8),
                        Text(
                          'Không tải được ảnh',
                          style: TextStyle(color: Colors.grey[500], fontSize: 12),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Full screen image view with zoom support
class FullscreenImagePage extends StatelessWidget {
  const FullscreenImagePage({
    super.key,
    required this.imagePath,
    required this.heroTag,
  });

  final String imagePath;
  final String heroTag;

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
        child: Hero(
          tag: heroTag,
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.broken_image, color: Colors.white54, size: 64),
                    const SizedBox(height: 16),
                    Text(
                      'Không tải được ảnh',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
