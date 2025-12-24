import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/entities/puzzle.dart';
import 'confetti_celebration.dart';

/// Completion celebration widget
class CompletionCelebration extends StatefulWidget {
  const CompletionCelebration({
    super.key,
    required this.puzzle,
    required this.foundWords,
    required this.onComplete,
  });

  final Puzzle puzzle;
  final Set<String> foundWords;
  final VoidCallback onComplete;

  @override
  State<CompletionCelebration> createState() => _CompletionCelebrationState();
}

class _CompletionCelebrationState extends State<CompletionCelebration> {
  bool _showConfetti = true;
  bool _showWords = false;

  @override
  void initState() {
    super.initState();
    // Show confetti first
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _showConfetti = false;
          _showWords = true;
        });
        // Show words for 1.5 seconds
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) {
            widget.onComplete();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_showConfetti)
          ConfettiCelebration(
            onComplete: () {},
          ),
        if (_showWords)
          _WordRevealOverlay(
            puzzle: widget.puzzle,
            foundWords: widget.foundWords,
          )
              .animate()
              .fadeIn(duration: 500.ms),
      ],
    );
  }
}

class _WordRevealOverlay extends StatelessWidget {
  const _WordRevealOverlay({
    required this.puzzle,
    required this.foundWords,
  });

  final Puzzle puzzle;
  final Set<String> foundWords;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _WordRevealPainter(
        puzzle: puzzle,
        foundWords: foundWords,
      ),
      child: Container(),
    );
  }
}

class _WordRevealPainter extends CustomPainter {
  _WordRevealPainter({
    required this.puzzle,
    required this.foundWords,
  });

  final Puzzle puzzle;
  final Set<String> foundWords;

  @override
  void paint(Canvas canvas, Size size) {
    // Highlight all found words
    // This would need cell size to draw properly
    // For now, just a placeholder - word reveal is handled in the grid overlay
  }

  @override
  bool shouldRepaint(_WordRevealPainter oldDelegate) => false;
}

