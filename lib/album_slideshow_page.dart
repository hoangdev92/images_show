import 'dart:async';

import 'package:flutter/material.dart';

/// Page to show full album as a slideshow.
/// Images are provided via [imagePaths].
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

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    if (widget.imagePaths.length <= 1) return;
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) return;
      _currentIndex = (_currentIndex + 1) % widget.imagePaths.length;
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
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
      appBar: AppBar(title: const Text('Album'), backgroundColor: Colors.black),
      body: Center(
        child: PageView.builder(
          controller: _pageController,
          itemCount: widget.imagePaths.length,
          onPageChanged: (index) {
            _currentIndex = index;
          },
          itemBuilder: (context, index) {
            final path = widget.imagePaths[index];
            return AnimatedBuilder(
              animation: _pageController,
              builder: (context, child) {
                double value = 1.0;
                if (_pageController.position.haveDimensions) {
                  final currentPage =
                      _pageController.page ??
                      _pageController.initialPage.toDouble();
                  value = currentPage - index;
                  value = (1 - (value.abs() * 0.3)).clamp(0.7, 1.0).toDouble();
                }
                return Center(
                  child: Transform.scale(scale: value, child: child),
                );
              },
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => FullscreenImagePage(
                        imagePath: path,
                        heroTag: 'album-image-$index',
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: 'album-image-$index',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: Image.asset(path, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Full screen image view with back button.
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
      appBar: AppBar(backgroundColor: Colors.black, title: const Text('Ảnh')),
      body: Center(
        child: Hero(
          tag: heroTag,
          child: InteractiveViewer(
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
