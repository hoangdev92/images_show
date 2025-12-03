import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math' as math;
import 'dart:async';

import 'album_slideshow_page.dart';
import 'widgets/perspective_view.dart';

/// Screen to display 3D image effect and background slideshow
/// Optimized for mobile and web performance
class Image3DView extends StatefulWidget {
  const Image3DView({super.key});

  @override
  State<Image3DView> createState() => _Image3DViewState();
}

class _Image3DViewState extends State<Image3DView>
    with TickerProviderStateMixin {
  // Shape mode: 'cube' or 'ring'
  String _shapeMode = 'cube';
  bool _isAutoLoad = false;

  // Background slideshow
  int _currentBgIndex = 0;
  Timer? _bgTimer;
  int _bgCounter = 0;
  bool _bgImageLoaded = false;

  // Audio player
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _currentAudioIndex = 0;
  bool _isPlaying = false;

  // Animation controllers
  late AnimationController _rotationController;
  late AnimationController _transformController;

  // List of images (12 images)
  final List<String> _imagePaths = List.generate(
    12,
    (index) => 'assets/img/${index + 1}.jpg',
  );

  // List of background images
  final List<String> _bgPaths = List.generate(
    10,
    (index) => 'assets/bg/${index + 1}.jpg',
  );

  // Album images - loaded dynamically
  List<String> _albumImages = [];
  bool _albumLoading = true;

  // Audio files
  final List<String> _audioUrls = [
    'assets/audio/A_Little_Love.mp3',
    'assets/audio/Beautiful_In_White.mp3',
    'assets/audio/Girls_Like_You.mp3',
    'assets/audio/I_Do.mp3',
    'assets/audio/Im_Yours.mp3',
    'assets/audio/My_Girl.mp3',
    'assets/audio/Proud_Of_You.mp3',
    'assets/audio/That_Girl.mp3',
    'assets/audio/There_For_You.mp3',
    'assets/audio/What_Makes_You_Beautiful.mp3',
  ];

  @override
  void initState() {
    super.initState();

    // Slower animation for better mobile performance (12 seconds instead of 8)
    _rotationController = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    )..repeat();

    _transformController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Load resources
    _loadAlbumImages();
    _precacheImages();

    // Start timers with delay to avoid initial lag
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _startBackgroundTimer();
        _startAutoToggle();
      }
    });

    _initAudioPlayer();
  }

  /// Precache images for smoother loading
  void _precacheImages() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Precache 3D images
      for (final path in _imagePaths) {
        precacheImage(AssetImage(path), context).catchError((_) {});
      }
      // Precache ALL background images for smooth transitions
      if (_bgPaths.isNotEmpty) {
        // Load first background immediately, then show UI
        precacheImage(AssetImage(_bgPaths[0]), context).then((_) {
          if (mounted) setState(() => _bgImageLoaded = true);
          // Precache remaining backgrounds in background
          for (int i = 1; i < _bgPaths.length; i++) {
            precacheImage(AssetImage(_bgPaths[i]), context).catchError((_) {});
          }
        }).catchError((_) {
          if (mounted) setState(() => _bgImageLoaded = true);
        });
      }
    });
  }

  /// Load album images from AssetManifest
  Future<void> _loadAlbumImages() async {
    try {
      final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      final allAssets = assetManifest.listAssets();

      final images = allAssets
          .where((path) =>
              path.startsWith('assets/images/') &&
              (path.toLowerCase().endsWith('.jpg') ||
                  path.toLowerCase().endsWith('.jpeg') ||
                  path.toLowerCase().endsWith('.png')))
          .toList();

      images.sort();

      if (mounted) {
        setState(() {
          _albumImages = images;
          _albumLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading album images: $e');
      if (mounted) {
        setState(() => _albumLoading = false);
      }
    }
  }

  void _startBackgroundTimer() {
    // Slower interval for better performance
    _bgTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted) return;
      setState(() {
        _bgCounter++;
        // Toggle shape every 16 seconds (8 ticks)
        if (_bgCounter >= 8) {
          _bgCounter = 0;
          _toggleShape();
        }
        // Change background every 20 seconds (10 ticks)
        if (_bgCounter == 5) {
          _currentBgIndex = (_currentBgIndex + 1) % _bgPaths.length;
        }
      });
    });
  }

  void _toggleShape() {
    setState(() {
      if (_shapeMode == 'cube' || _isAutoLoad) {
        _shapeMode = 'ring';
        _isAutoLoad = false;
      } else {
        _shapeMode = 'cube';
      }
      _transformController.forward(from: 0);
    });
  }

  void _startAutoToggle() {
    Timer.periodic(const Duration(seconds: 16), (timer) {
      if (!mounted) return;
      if (_shapeMode == 'cube') {
        setState(() => _isAutoLoad = true);
      } else {
        _toggleShape();
      }
    });
  }

  void _initAudioPlayer() {
    _currentAudioIndex = math.Random().nextInt(_audioUrls.length);
    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) _playNextAudio();
    });
  }

  Future<void> _playAudio(String assetPath) async {
    try {
      final path = assetPath.startsWith('assets/')
          ? assetPath.substring(7)
          : assetPath;
      await _audioPlayer.play(AssetSource(path));
      if (mounted) setState(() => _isPlaying = true);
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }

  void _playNextAudio() {
    setState(() {
      _currentAudioIndex = (_currentAudioIndex + 1) % _audioUrls.length;
    });
    _playAudio(_audioUrls[_currentAudioIndex]);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _transformController.dispose();
    _bgTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 600;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image with fade animation (full resolution for sharp display)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 800),
            child: _bgImageLoaded
                ? Image.asset(
                    _bgPaths[_currentBgIndex],
                    key: ValueKey(_currentBgIndex),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    // Full resolution - no cacheWidth limit
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.black87,
                    ),
                  )
                : Container(
                    color: Colors.black87,
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white54),
                    ),
                  ),
          ),

          // Dark overlay for better contrast
          Container(color: Colors.black.withOpacity(0.3)),

          // Top controls
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            right: 10,
            child: _buildControls(isMobile),
          ),

          // 3D Shape container - centered and responsive
          Center(
            child: SizedBox(
              width: screenSize.width,
              height: isMobile ? screenSize.height * 0.6 : screenSize.height * 0.75,
              child: PerspectiveView(
                shapeMode: _isAutoLoad ? 'autoLoad' : _shapeMode,
                rotationAnimation: _rotationController,
                imagePaths: _imagePaths,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(bool isMobile) {
    return Row(
      children: [
        // Album button
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black54,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 16,
              vertical: isMobile ? 8 : 12,
            ),
          ),
          onPressed: _albumLoading || _albumImages.isEmpty
              ? null
              : () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AlbumSlideshowPage(imagePaths: _albumImages),
                    ),
                  );
                },
          icon: _albumLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.photo_library, size: 20),
          label: Text(
            _albumLoading
                ? 'Loading...'
                : 'Album (${_albumImages.length})',
            style: TextStyle(fontSize: isMobile ? 12 : 14),
          ),
        ),
        const Spacer(),
        // Audio controls
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                iconSize: isMobile ? 20 : 24,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: () async {
                  if (_isPlaying) {
                    await _audioPlayer.pause();
                    setState(() => _isPlaying = false);
                  } else {
                    await _playAudio(_audioUrls[_currentAudioIndex]);
                  }
                },
              ),
              const SizedBox(width: 8),
              Text(
                '${_currentAudioIndex + 1}/${_audioUrls.length}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 11 : 12,
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ],
    );
  }
}
