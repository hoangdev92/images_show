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
        _buildPlane(
          imagePaths[0],
          transform: Matrix4.identity()
            ..scale(scale, scale, scale)
            ..rotateX(math.pi / 2)
            ..translate(0.0, 0.0, translateZ),
          opacity: opacity,
        ),
        _buildPlane(
          imagePaths[1],
          transform: Matrix4.identity()
            ..scale(scale, scale, scale)
            ..translate(0.0, 0.0, translateZ),
          opacity: opacity,
        ),
        _buildPlane(
          imagePaths[2],
          transform: Matrix4.identity()
            ..scale(scale, scale, scale)
            ..rotateY(math.pi / 2)
            ..translate(0.0, 0.0, translateZ),
          opacity: opacity,
        ),
        _buildPlane(
          imagePaths[3],
          transform: Matrix4.identity()
            ..scale(scale, scale, scale)
            ..rotateY(math.pi)
            ..translate(0.0, 0.0, translateZ),
          opacity: opacity,
        ),
        _buildPlane(
          imagePaths[4],
          transform: Matrix4.identity()
            ..scale(scale, scale, scale)
            ..rotateY(-math.pi / 2)
            ..translate(0.0, 0.0, translateZ),
          opacity: opacity,
        ),
        _buildPlane(
          imagePaths[5],
          transform: Matrix4.identity()
            ..scale(scale, scale, scale)
            ..rotateX(-math.pi / 2)
            ..translate(0.0, 0.0, translateZ)
            ..rotateZ(math.pi),
          opacity: opacity,
        ),
        _buildPlane(
          imagePaths[6],
          transform: Matrix4.identity()
            ..scale(0.8, 0.8, 0.8)
            ..rotateX(math.pi / 2)
            ..translate(0.0, 0.0, 100.0)
            ..rotateZ(math.pi),
        ),
        _buildPlane(
          imagePaths[7],
          transform: Matrix4.identity()
            ..scale(0.8, 0.8, 0.8)
            ..translate(0.0, 0.0, 100.0),
        ),
        _buildPlane(
          imagePaths[8],
          transform: Matrix4.identity()
            ..scale(0.8, 0.8, 0.8)
            ..rotateY(math.pi / 2)
            ..translate(0.0, 0.0, 100.0),
        ),
        _buildPlane(
          imagePaths[9],
          transform: Matrix4.identity()
            ..scale(0.8, 0.8, 0.8)
            ..rotateY(math.pi)
            ..translate(0.0, 0.0, 100.0),
        ),
        _buildPlane(
          imagePaths[10],
          transform: Matrix4.identity()
            ..scale(0.8, 0.8, 0.8)
            ..rotateY(-math.pi / 2)
            ..translate(0.0, 0.0, 100.0),
        ),
        _buildPlane(
          imagePaths[11],
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
    const double angleStep = 2 * math.pi / 12;

    return Stack(
      children: List.generate(12, (index) {
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
          ),
          color: Colors.white.withOpacity(0.6 * opacity),
        ),
      ),
    );
  }
}
