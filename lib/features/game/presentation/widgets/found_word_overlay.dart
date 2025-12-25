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
    required this.margin,
    this.onAnimationComplete,
  });

  final Puzzle puzzle;
  final Set<String> foundWords;
  final double cellSize;
  final double margin;
  final VoidCallback? onAnimationComplete;

  @override
  State<FoundWordOverlay> createState() => _FoundWordOverlayState();
}

class _FoundWordOverlayState extends State<FoundWordOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  /// Words that have completed their animation (drawn at full)
  Set<String> _animatedWords = {};
  /// The word currently being animated
  String? _animatingWord;

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
    
    // Find any initial words to animate
    if (widget.foundWords.isNotEmpty) {
      _animatingWord = widget.foundWords.first;
      _controller.forward().then((_) {
        _onAnimationComplete();
      });
    }
  }

  void _onAnimationComplete() {
    if (_animatingWord != null) {
      setState(() {
        _animatedWords = {..._animatedWords, _animatingWord!};
        _animatingWord = null;
      });
    }
    widget.onAnimationComplete?.call();
  }

  @override
  void didUpdateWidget(FoundWordOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Find newly added words
    final newWords = widget.foundWords.difference(oldWidget.foundWords);
    if (newWords.isNotEmpty) {
      // Animate only the new word
      setState(() {
        _animatingWord = newWords.first;
      });
      _controller.reset();
      _controller.forward().then((_) {
        _onAnimationComplete();
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
              margin: widget.margin,
              animationValue: _animation.value,
              animatingWord: _animatingWord,
              animatedWords: _animatedWords,
            ),
            child: Container(),
          );
        },
      ),
    );
  }
}

