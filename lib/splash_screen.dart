import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'image_3d_view.dart';

/// Splash screen: re-implemented effect from c.html (heart particles on canvas)
/// and after ~8 seconds navigate to Image3DView.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final HeartParticleSystem _system;
  double _lastTime = 0;

  @override
  void initState() {
    super.initState();

    _system = HeartParticleSystem();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 4,
      ), // loop duration similar to JS settings.particles.duration
    )..addListener(_tick);

    _controller.repeat();

    // After 8 seconds, navigate to main 3D screen.
    Timer(const Duration(seconds: 8), () {
      if (!mounted) return;
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const Image3DView()));
    });
  }

  void _tick() {
    final now = DateTime.now().millisecondsSinceEpoch / 1000.0;
    final dt = _lastTime == 0 ? 0.0 : (now - _lastTime);
    _lastTime = now;

    // Limit dt to avoid huge jumps if app was paused.
    final clampedDt = dt.clamp(0.0, 0.05);

    // Update particle system and repaint.
    _system.update(clampedDt);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.85),
      body: LayoutBuilder(
        builder: (context, constraints) {
          _system.setSize(constraints.maxWidth, constraints.maxHeight);
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: HeartParticlePainter(_system),
              );
            },
          );
        },
      ),
    );
  }
}

/// Simple 2D point used for particle position / velocity.
class _Point {
  double x;
  double y;

  _Point(this.x, this.y);

  _Point clone() => _Point(x, y);

  double length() => math.sqrt(x * x + y * y);

  _Point normalize() {
    final len = length();
    if (len == 0) return this;
    x /= len;
    y /= len;
    return this;
  }

  _Point scale(double s) {
    x *= s;
    y *= s;
    return this;
  }
}

/// Represents a single particle (small heart) in the scene.
class _Particle {
  final _Point position = _Point(0, 0);
  final _Point velocity = _Point(0, 0);
  final _Point acceleration = _Point(0, 0);
  double age = 0;

  void initialize(double x, double y, double dx, double dy, double effect) {
    position
      ..x = x
      ..y = y;
    velocity
      ..x = dx
      ..y = dy;
    acceleration
      ..x = dx * effect
      ..y = dy * effect;
    age = 0;
  }

  void update(double dt) {
    position
      ..x += velocity.x * dt
      ..y += velocity.y * dt;
    velocity
      ..x += acceleration.x * dt
      ..y += acceleration.y * dt;
    age += dt;
  }
}

/// Port of the JS particle pool logic into Dart.
class HeartParticleSystem extends ChangeNotifier {
  // Settings (ported from JS settings object).
  static const int maxParticles =
      800; // lower than 10000 to keep Flutter smooth
  static const double duration = 4.0; // seconds
  static const double velocity = 80.0;
  static const double effect = -1.3;
  static const double particleSize = 8.0;

  final List<_Particle> _particles = List<_Particle>.generate(
    maxParticles,
    (_) => _Particle(),
  );

  int _firstActive = 0;
  int _firstFree = 0;

  double _width = 0;
  double _height = 0;

  double get _particleRate => maxParticles / duration;

  void setSize(double width, double height) {
    _width = width;
    _height = height;
  }

  void addParticle(double x, double y, double dx, double dy) {
    _particles[_firstFree].initialize(x, y, dx, dy, effect);
    _firstFree++;
    if (_firstFree == _particles.length) _firstFree = 0;
    if (_firstActive == _firstFree) {
      _firstActive++;
      if (_firstActive == _particles.length) _firstActive = 0;
    }
  }

  void update(double dt) {
    if (_width == 0 || _height == 0 || dt <= 0) {
      return;
    }

    // Create new particles following heart curve.
    final amount = _particleRate * dt;
    for (int i = 0; i < amount; i++) {
      final pos = _pointOnHeart(
        math.pi - 2 * math.pi * math.Random().nextDouble(),
      );
      final dir = pos.clone().normalize().scale(
        velocity,
      ); // scale to desired speed like JS length()

      addParticle(_width / 2 + pos.x, _height / 2 - pos.y, dir.x, -dir.y);
    }

    // Update active particles
    if (_firstActive < _firstFree) {
      for (int i = _firstActive; i < _firstFree; i++) {
        _particles[i].update(dt);
      }
    } else if (_firstFree < _firstActive) {
      for (int i = _firstActive; i < _particles.length; i++) {
        _particles[i].update(dt);
      }
      for (int i = 0; i < _firstFree; i++) {
        _particles[i].update(dt);
      }
    }

    // Remove inactive particles
    while (_particles[_firstActive].age >= duration &&
        _firstActive != _firstFree) {
      _firstActive++;
      if (_firstActive == _particles.length) _firstActive = 0;
    }

    notifyListeners();
  }

  Iterable<_Particle> get activeParticles sync* {
    if (_firstActive < _firstFree) {
      for (int i = _firstActive; i < _firstFree; i++) {
        yield _particles[i];
      }
    } else if (_firstFree < _firstActive) {
      for (int i = _firstActive; i < _particles.length; i++) {
        yield _particles[i];
      }
      for (int i = 0; i < _firstFree; i++) {
        yield _particles[i];
      }
    }
  }

  // Heart parametric curve, same formula as in c.html.
  _Point _pointOnHeart(double t) {
    final x = 160 * math.pow(math.sin(t), 3) as double;
    final y =
        130 * math.cos(t) -
        50 * math.cos(2 * t) -
        20 * math.cos(3 * t) -
        10 * math.cos(4 * t) +
        25;
    return _Point(x, y);
  }
}

/// Painter that draws all active particles as small hearts.
class HeartParticlePainter extends CustomPainter {
  final HeartParticleSystem system;

  HeartParticlePainter(this.system) : super(repaint: system);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFF50B02);

    for (final p in system.activeParticles) {
      final life = (p.age / HeartParticleSystem.duration).clamp(0.0, 1.0);
      final eased = _easeOutCubic(1 - life);
      final currentSize = HeartParticleSystem.particleSize * (0.5 + eased);

      final opacity = 1 - life;
      paint.color = const Color(0xFFF50B02).withOpacity(opacity);

      _drawHeart(
        canvas,
        Offset(p.position.x, p.position.y),
        currentSize,
        paint,
      );
    }
  }

  double _easeOutCubic(double t) {
    t = 1 - t;
    return 1 - t * t * t;
  }

  // Draw a small heart shape centered at [center] with approximate [size].
  void _drawHeart(Canvas canvas, Offset center, double size, Paint paint) {
    final width = size;
    final height = size;
    final path = Path();

    final topCenter = Offset(center.dx, center.dy - height * 0.25);
    final leftControl = Offset(
      center.dx - width * 0.5,
      center.dy - height * 0.75,
    );
    final left = Offset(center.dx - width * 0.5, center.dy - height * 0.1);
    final bottom = Offset(center.dx, center.dy + height * 0.5);
    final right = Offset(center.dx + width * 0.5, center.dy - height * 0.1);
    final rightControl = Offset(
      center.dx + width * 0.5,
      center.dy - height * 0.75,
    );

    path.moveTo(topCenter.dx, topCenter.dy);
    path.cubicTo(
      leftControl.dx,
      leftControl.dy,
      left.dx,
      left.dy,
      bottom.dx,
      bottom.dy,
    );
    path.cubicTo(
      right.dx,
      right.dy,
      rightControl.dx,
      rightControl.dy,
      topCenter.dx,
      topCenter.dy,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant HeartParticlePainter oldDelegate) => true;
}
