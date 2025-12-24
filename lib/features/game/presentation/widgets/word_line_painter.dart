import 'package:flutter/material.dart';
import '../../domain/entities/word_position.dart';
import '../../../../core/theme/theme.dart';

/// Custom painter for drawing word lines
class WordLinePainter extends CustomPainter {
  WordLinePainter({
    required this.foundWords,
    required this.wordPositions,
    required this.cellSize,
    required this.animationValue,
  });

  final Set<String> foundWords;
  final List<WordPosition> wordPositions;
  final double cellSize;
  final double animationValue; // 0.0 to 1.0 for animation

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw lines for found words
    for (final wordPos in wordPositions) {
      if (foundWords.contains(wordPos.word)) {
        final path = wordPos.getLinePath(cellSize, 2.0);
        
        // Animate the line drawing
        if (animationValue < 1.0) {
          final animatedPath = _createAnimatedPath(path, animationValue);
          canvas.drawPath(animatedPath, paint);
        } else {
          canvas.drawPath(path, paint);
        }
      }
    }
  }

  /// Create an animated path that draws from start to end
  Path _createAnimatedPath(Path originalPath, double progress) {
    final metrics = originalPath.computeMetrics().first;
    final length = metrics.length;
    final stopDistance = length * progress;
    
    final animatedPath = Path();
    final stopPoint = metrics.getTangentForOffset(stopDistance);
    
    if (stopPoint != null) {
      animatedPath.moveTo(metrics.getTangentForOffset(0)!.position.dx,
                          metrics.getTangentForOffset(0)!.position.dy);
      animatedPath.lineTo(stopPoint.position.dx, stopPoint.position.dy);
    }
    
    return animatedPath;
  }

  @override
  bool shouldRepaint(WordLinePainter oldDelegate) {
    return oldDelegate.foundWords != foundWords ||
        oldDelegate.animationValue != animationValue ||
        oldDelegate.cellSize != cellSize;
  }
}

