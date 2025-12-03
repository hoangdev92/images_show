import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Widget to build cube / ring 3D effect using 2D transforms.
class PerspectiveView extends StatelessWidget {
  final String shapeMode;
  final Animation<double> rotationAnimation;
  final List<String> imagePaths;

  const PerspectiveView({
    super.key,
    required this.shapeMode,
    required this.rotationAnimation,
    required this.imagePaths,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: rotationAnimation,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // Perspective
            ..rotateY(rotationAnimation.value * 2 * math.pi),
          alignment: Alignment.center,
          child: _buildShape(),
        );
      },
    );
  }

  Widget _buildShape() {
    if (shapeMode == 'ring') {
      return _buildRing();
    } else {
      return _buildCube();
    }
  }

  Widget _buildCube() {
    final isExpanded = shapeMode == 'autoLoad';
    final opacity = isExpanded ? 0.9 : 0.2;
    final scale = isExpanded ? 1.5 : 1.2;
    final translateZ = isExpanded ? 150.0 : 100.0;

    return Stack(
      children: [
        // OUTER CUBE - 6 faces with scale
        _buildPlane(
          imagePaths[0 % imagePaths.length],
          transform: Matrix4.identity()
            ..scale(scale, scale, scale)
            ..rotateX(math.pi / 2)
            ..translate(0.0, 0.0, translateZ),
          opacity: opacity,
        ),
        _buildPlane(
          imagePaths[1 % imagePaths.length],
          transform: Matrix4.identity()
            ..scale(scale, scale, scale)
            ..translate(0.0, 0.0, translateZ),
          opacity: opacity,
        ),
        _buildPlane(
          imagePaths[2 % imagePaths.length],
          transform: Matrix4.identity()
            ..scale(scale, scale, scale)
            ..rotateY(math.pi / 2)
            ..translate(0.0, 0.0, translateZ),
          opacity: opacity,
        ),
        _buildPlane(
          imagePaths[3 % imagePaths.length],
          transform: Matrix4.identity()
            ..scale(scale, scale, scale)
            ..rotateY(math.pi)
            ..translate(0.0, 0.0, translateZ),
          opacity: opacity,
        ),
        _buildPlane(
          imagePaths[4 % imagePaths.length],
          transform: Matrix4.identity()
            ..scale(scale, scale, scale)
            ..rotateY(-math.pi / 2)
            ..translate(0.0, 0.0, translateZ),
          opacity: opacity,
        ),
        _buildPlane(
          imagePaths[5 % imagePaths.length],
          transform: Matrix4.identity()
            ..scale(scale, scale, scale)
            ..rotateX(-math.pi / 2)
            ..translate(0.0, 0.0, translateZ)
            ..rotateZ(math.pi),
          opacity: opacity,
        ),
        // INNER CUBE - 6 faces (smaller, no extra scale)
        _buildPlane(
          imagePaths[6 % imagePaths.length],
          transform: Matrix4.identity()
            ..scale(0.8, 0.8, 0.8)
            ..rotateX(math.pi / 2)
            ..translate(0.0, 0.0, 100.0)
            ..rotateZ(math.pi),
        ),
        _buildPlane(
          imagePaths[7 % imagePaths.length],
          transform: Matrix4.identity()
            ..scale(0.8, 0.8, 0.8)
            ..translate(0.0, 0.0, 100.0),
        ),
        _buildPlane(
          imagePaths[8 % imagePaths.length],
          transform: Matrix4.identity()
            ..scale(0.8, 0.8, 0.8)
            ..rotateY(math.pi / 2)
            ..translate(0.0, 0.0, 100.0),
        ),
        _buildPlane(
          imagePaths[9 % imagePaths.length],
          transform: Matrix4.identity()
            ..scale(0.8, 0.8, 0.8)
            ..rotateY(math.pi)
            ..translate(0.0, 0.0, 100.0),
        ),
        _buildPlane(
          imagePaths[10 % imagePaths.length],
          transform: Matrix4.identity()
            ..scale(0.8, 0.8, 0.8)
            ..rotateY(-math.pi / 2)
            ..translate(0.0, 0.0, 100.0),
        ),
        _buildPlane(
          imagePaths[11 % imagePaths.length],
          transform: Matrix4.identity()
            ..scale(0.8, 0.8, 0.8)
            ..rotateX(-math.pi / 2)
            ..translate(0.0, 0.0, 100.0),
        ),
      ],
    );
  }

  Widget _buildRing() {
    const double radius = 380.0;
    final int itemCount = imagePaths.length;
    final double angleStep = 2 * math.pi / itemCount;

    return Stack(
      children: List.generate(itemCount, (index) {
        final angle = index * angleStep;
        return _buildPlane(
          imagePaths[index],
          transform: Matrix4.identity()
            ..rotateY(angle)
            ..translate(0.0, 0.0, radius),
        );
      }),
    );
  }

  Widget _buildPlane(
    String imagePath, {
    required Matrix4 transform,
    double opacity = 1.0,
  }) {
    return Transform(
      transform: transform,
      alignment: Alignment.center,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white, width: 1),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(opacity),
              BlendMode.modulate,
            ),
          ),
          color: Colors.white.withOpacity(0.6 * opacity),
        ),
      ),
    );
  }
}
