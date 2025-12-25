import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/entities/word_position.dart';

/// Flash animation for when a word is found
class WordFoundAnimation extends StatelessWidget {
  const WordFoundAnimation({
    super.key,
    required this.wordPosition,
    required this.cellSize,
    required this.margin,
    required this.onComplete,
  });

  final WordPosition wordPosition;
  final double cellSize;
  final double margin;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _FlashPainter(
          wordPosition: wordPosition,
          cellSize: cellSize,
          margin: margin,
        ),
        child: Container(),
      )
          .animate()
          .fadeIn(duration: 150.ms)
          .then()
          .fadeOut(duration: 150.ms)
          .then()
          .callback(callback: (_) => onComplete()),
    );
  }
}

class _FlashPainter extends CustomPainter {
  _FlashPainter({
    required this.wordPosition,
    required this.cellSize,
    required this.margin,
  });

  final WordPosition wordPosition;
  final double cellSize;
  final double margin;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.success.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    // Highlight all cells in the word
    for (final (row, col) in wordPosition.cells) {
      const padding = 4.0;
      const totalOffset = padding;
      final cellWithMargin = cellSize + (margin * 2);
      
      final x = totalOffset + (col * cellWithMargin) + margin;
      final y = totalOffset + (row * cellWithMargin) + margin;
      
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, cellSize, cellSize),
          const Radius.circular(8),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_FlashPainter oldDelegate) => false;
}

