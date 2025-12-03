import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Widget to build cube / ring 3D effect using 2D transforms.
/// Responsive - auto calculates sizes based on screen dimensions.
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
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive sizes based on available space
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        final minDimension = math.min(screenWidth, screenHeight);

        // Base size for planes - responsive to screen size
        // Use smaller percentage for mobile compatibility
        final planeSize = minDimension * 0.22;

        // Radius for ring and translateZ for cube - proportional to plane size
        final radius = planeSize * 1.8;
        final translateZ = planeSize * 0.5;
        final innerTranslateZ = planeSize * 0.5;

        return Center(
          child: SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: Center(
              child: AnimatedBuilder(
                animation: rotationAnimation,
                builder: (context, child) {
                  return Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001) // Perspective
                      ..rotateY(rotationAnimation.value * 2 * math.pi),
                    alignment: Alignment.center,
                    child: _buildShape(
                      planeSize: planeSize,
                      radius: radius,
                      translateZ: translateZ,
                      innerTranslateZ: innerTranslateZ,
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShape({
    required double planeSize,
    required double radius,
    required double translateZ,
    required double innerTranslateZ,
  }) {
    if (shapeMode == 'ring') {
      return _buildRing(planeSize: planeSize, radius: radius);
    } else {
      return _buildCube(
        planeSize: planeSize,
        translateZ: translateZ,
        innerTranslateZ: innerTranslateZ,
      );
    }
  }

  Widget _buildCube({
    required double planeSize,
    required double translateZ,
    required double innerTranslateZ,
  }) {
    final isExpanded = shapeMode == 'autoLoad';
    final opacity = isExpanded ? 0.9 : 0.2;
    final scale = isExpanded ? 1.3 : 1.0;
    final outerZ = isExpanded ? translateZ * 1.5 : translateZ;

    // Outer cube (6 faces) - indices 0-5
    // Inner cube (6 faces) - indices 6-9 (reuse if less than 12 images)
    final outerPlaneSize = planeSize * scale;
    final innerPlaneSize = planeSize * 0.7;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer cube - Top face
        _buildPlane(
          _getImagePath(0),
          planeSize: outerPlaneSize,
          transform: Matrix4.identity()
            ..rotateX(math.pi / 2)
            ..translate(0.0, 0.0, outerZ),
          opacity: opacity,
        ),
        // Outer cube - Front face
        _buildPlane(
          _getImagePath(1),
          planeSize: outerPlaneSize,
          transform: Matrix4.identity()..translate(0.0, 0.0, outerZ),
          opacity: opacity,
        ),
        // Outer cube - Right face
        _buildPlane(
          _getImagePath(2),
          planeSize: outerPlaneSize,
          transform: Matrix4.identity()
            ..rotateY(math.pi / 2)
            ..translate(0.0, 0.0, outerZ),
          opacity: opacity,
        ),
        // Outer cube - Back face
        _buildPlane(
          _getImagePath(3),
          planeSize: outerPlaneSize,
          transform: Matrix4.identity()
            ..rotateY(math.pi)
            ..translate(0.0, 0.0, outerZ),
          opacity: opacity,
        ),
        // Outer cube - Left face
        _buildPlane(
          _getImagePath(4),
          planeSize: outerPlaneSize,
          transform: Matrix4.identity()
            ..rotateY(-math.pi / 2)
            ..translate(0.0, 0.0, outerZ),
          opacity: opacity,
        ),
        // Outer cube - Bottom face
        _buildPlane(
          _getImagePath(5),
          planeSize: outerPlaneSize,
          transform: Matrix4.identity()
            ..rotateX(-math.pi / 2)
            ..translate(0.0, 0.0, outerZ)
            ..rotateZ(math.pi),
          opacity: opacity,
        ),
        // Inner cube - Top face
        _buildPlane(
          _getImagePath(6),
          planeSize: innerPlaneSize,
          transform: Matrix4.identity()
            ..rotateX(math.pi / 2)
            ..translate(0.0, 0.0, innerTranslateZ)
            ..rotateZ(math.pi),
        ),
        // Inner cube - Front face
        _buildPlane(
          _getImagePath(7),
          planeSize: innerPlaneSize,
          transform: Matrix4.identity()..translate(0.0, 0.0, innerTranslateZ),
        ),
        // Inner cube - Right face
        _buildPlane(
          _getImagePath(8),
          planeSize: innerPlaneSize,
          transform: Matrix4.identity()
            ..rotateY(math.pi / 2)
            ..translate(0.0, 0.0, innerTranslateZ),
        ),
        // Inner cube - Back face
        _buildPlane(
          _getImagePath(9),
          planeSize: innerPlaneSize,
          transform: Matrix4.identity()
            ..rotateY(math.pi)
            ..translate(0.0, 0.0, innerTranslateZ),
        ),
      ],
    );
  }

  Widget _buildRing({required double planeSize, required double radius}) {
    final itemCount = imagePaths.length;
    final angleStep = 2 * math.pi / itemCount;

    return Stack(
      alignment: Alignment.center,
      children: List.generate(itemCount, (index) {
        final angle = index * angleStep;
        return _buildPlane(
          _getImagePath(index),
          planeSize: planeSize,
          transform: Matrix4.identity()
            ..rotateY(angle)
            ..translate(0.0, 0.0, radius),
        );
      }),
    );
  }

  /// Get image path safely with bounds checking
  String _getImagePath(int index) {
    if (imagePaths.isEmpty) return '';
    return imagePaths[index % imagePaths.length];
  }

  Widget _buildPlane(
    String imagePath, {
    required double planeSize,
    required Matrix4 transform,
    double opacity = 1.0,
  }) {
    if (imagePath.isEmpty) return const SizedBox.shrink();

    return Transform(
      transform: transform,
      alignment: Alignment.center,
      child: Container(
        width: planeSize,
        height: planeSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(planeSize * 0.06),
          border: Border.all(color: Colors.white, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(opacity),
              BlendMode.modulate,
            ),
          ),
        ),
      ),
    );
  }
}
