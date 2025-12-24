import 'package:flutter/material.dart';
import '../../domain/entities/puzzle.dart';
import 'word_line_painter.dart';

/// Overlay widget that draws lines for found words
class FoundWordOverlay extends StatefulWidget {
  const FoundWordOverlay({
    super.key,
    required this.puzzle,
    required this.foundWords,
    required this.cellSize,
    this.onAnimationComplete,
  });

  final Puzzle puzzle;
  final Set<String> foundWords;
  final double cellSize;
  final VoidCallback? onAnimationComplete;

  @override
  State<FoundWordOverlay> createState() => _FoundWordOverlayState();
}

class _FoundWordOverlayState extends State<FoundWordOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward().then((_) {
      widget.onAnimationComplete?.call();
    });
  }

  @override
  void didUpdateWidget(FoundWordOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If new words were found, restart animation
    if (widget.foundWords.length > oldWidget.foundWords.length) {
      _controller.reset();
      _controller.forward().then((_) {
        widget.onAnimationComplete?.call();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: WordLinePainter(
              foundWords: widget.foundWords,
              wordPositions: widget.puzzle.words,
              cellSize: widget.cellSize,
              animationValue: _animation.value,
            ),
            child: Container(),
          );
        },
      ),
    );
  }
}

