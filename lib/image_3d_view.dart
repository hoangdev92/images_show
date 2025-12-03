import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math' as math;
import 'dart:async';

import 'album_slideshow_page.dart';
import 'widgets/perspective_view.dart';

/// Screen to display 3D image effect and background slideshow
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

  // List of background images (10 images)
  final List<String> _bgPaths = List.generate(
    10,
    (index) => 'assets/bg/${index + 1}.jpg',
  );

  // Album images (full album slideshow)
  // NOTE: Update this list to match files you put in assets/images/
  final List<String> _albumImages = const [
    'assets/images/1.jpg',
    'assets/images/2.jpg',
    'assets/images/3.jpg',
    'assets/images/4.jpg',
    'assets/images/5.jpg',
  ];

  // Audio URLs (you can replace with your own URLs)
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

    // Initialize rotation animation (8 seconds infinite)
    _rotationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    // Initialize transform animation for shape changes
    _transformController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Start background slideshow timer
    _startBackgroundTimer();

    // Initialize audio player
    _initAudioPlayer();

    // Auto toggle shape every 8 seconds
    _startAutoToggle();
  }

  void _startBackgroundTimer() {
    _bgTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        // Auto toggle shape after a period, similar to original JS
        if (_bgCounter >= 8) {
          _bgCounter = 0;
          _toggleShape();
        } else {
          _bgCounter++;
        }

        // Change background image after some time
        if (_bgCounter >= 15) {
          _currentBgIndex = (_currentBgIndex + 1) % _bgPaths.length;
          _bgCounter = 0;
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
    Timer.periodic(const Duration(seconds: 8), (timer) {
      if (_shapeMode == 'cube') {
        setState(() {
          _isAutoLoad = true;
        });
      } else {
        _toggleShape();
      }
    });
  }

  void _initAudioPlayer() async {
    // Select random audio
    _currentAudioIndex = math.Random().nextInt(_audioUrls.length);
    await _playAudio(_audioUrls[_currentAudioIndex]);

    // Listen for audio completion
    _audioPlayer.onPlayerComplete.listen((event) {
      _playNextAudio();
    });
  }

  Future<void> _playAudio(String url) async {
    try {
      await _audioPlayer.play(UrlSource(url));
      setState(() {
        _isPlaying = true;
      });
    } catch (e) {
      // Audio might not be available or blocked (for example by CORS)
      // Just print error to debug console
      // In production you should handle this state in UI
      // ignore: avoid_print
      print('Error playing audio: $e');
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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_bgPaths[_currentBgIndex]),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Top panel with album button + audio controls
            Positioned(
              top: 10,
              left: 5,
              right: 5,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Row(
                  children: [
                    // Button xem full album (top-left)
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black.withOpacity(0.5),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        if (_albumImages.isEmpty) return;
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                AlbumSlideshowPage(imagePaths: _albumImages),
                          ),
                        );
                      },
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Xem full album'),
                    ),
                    const Spacer(),
                    // Simple audio control (top-right)
                    SizedBox(
                      width: 260,
                      height: 30,
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              if (_isPlaying) {
                                await _audioPlayer.pause();
                                setState(() {
                                  _isPlaying = false;
                                });
                              } else {
                                await _audioPlayer.resume();
                                setState(() {
                                  _isPlaying = true;
                                });
                              }
                            },
                          ),
                          Expanded(
                            child: Text(
                              'Track ${_currentAudioIndex + 1}/${_audioUrls.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 3D Shape container
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 708,
                child: PerspectiveView(
                  shapeMode: _isAutoLoad ? 'autoLoad' : _shapeMode,
                  rotationAnimation: _rotationController,
                  imagePaths: _imagePaths,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
