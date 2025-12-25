import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../theme/theme.dart';

/// A mini grid preview for difficulty selection
class GridPreview extends StatefulWidget {
  const GridPreview({
    super.key,
    required this.size,
    this.cellSize = 8,
    this.color,
  });

  final int size;
  final double cellSize;
  final Color? color;

  @override
  State<GridPreview> createState() => _GridPreviewState();
}

class _GridPreviewState extends State<GridPreview> {
  static const String _letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  late int _seed;
  late List<_PreviewWord> _words;

  @override
  void initState() {
    super.initState();
    _generatePaths();
  }

  @override
  void didUpdateWidget(covariant GridPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.size != widget.size) {
      _generatePaths();
    }
  }

  void _generatePaths() {
    _seed = DateTime.now().microsecondsSinceEpoch;
    _words = _buildPreviewWords(widget.size, _seed);
  }

  String _getRandomLetter(int row, int col) {
    var hash = (row * 31 + col * 17 + widget.size * 7);
    hash = hash ^ (hash >> 16);
    hash = hash * 0x85ebca6b;
    hash = hash ^ (hash >> 13);
    hash = hash * 0xc2b2ae35;
    hash = hash ^ (hash >> 16);
    final seed = hash.abs() % _letters.length;
    return _letters[seed];
  }

  Set<_PreviewCell> _buildHighlightedCells(List<_PreviewWord> words) {
    final highlighted = <_PreviewCell>{};

    for (final word in words) {
      final step = word.direction;
      for (int i = 0; i < word.length; i++) {
        highlighted.add(
          _PreviewCell(
            row: word.startRow + (step.dy * i).round(),
            col: word.startCol + (step.dx * i).round(),
          ),
        );
      }
    }
    return highlighted;
  }

  int _pathsForSize(int gridSize) {
    switch (gridSize) {
      case 8:
        return 6;
      case 12:
        return 10;
      case 15:
        return 15;
      default:
        return math.max(2, (gridSize / 2).round());
    }
  }

  List<_PreviewWord> _buildPreviewWords(int gridSize, int seed) {
    final rand = math.Random(seed);
    const directions = [
      Offset(1, 0),
      Offset(0, 1),
      Offset(1, 1),
      Offset(-1, 1),
    ];

    final desired = _pathsForSize(gridSize);
    final words = <_PreviewWord>[];
    var attempts = 0;
    final attemptLimit = desired * 30;
    final minDistance = gridSize <= 8
        ? 2.5
        : gridSize <= 12
        ? 2.0
        : 1.2;

    while (words.length < desired && attempts < attemptLimit) {
      attempts++;
      final dir = directions[rand.nextInt(directions.length)];
      final length = math.max(4, math.min(gridSize ~/ 2, 6 + gridSize ~/ 5));
      final startRow = rand.nextInt(gridSize);
      final startCol = rand.nextInt(gridSize);

      final endRow = startRow + ((length - 1) * dir.dy).round();
      final endCol = startCol + ((length - 1) * dir.dx).round();

      final inBounds =
          endRow >= 0 &&
          endRow < gridSize &&
          endCol >= 0 &&
          endCol < gridSize &&
          startRow >= 0 &&
          startCol >= 0;

      if (!inBounds) continue;

      final candidate = _PreviewWord(
        startRow: startRow,
        startCol: startCol,
        endRow: endRow,
        endCol: endCol,
      );

      final overlaps = words.any((w) => candidate.distanceTo(w) < minDistance);
      if (!overlaps) {
        words.add(candidate);
      }
    }

    return words;
  }

  @override
  Widget build(BuildContext context) {
    final previewSize = widget.size;
    final accent = widget.color ?? AppColors.primary;
    final highlightedCells = _buildHighlightedCells(_words);
    final containerPadding = 6.0;
    final cellMargin = 0.6;

    final baseCellSize = widget.cellSize;
    final gridDimension = previewSize * (baseCellSize + (cellMargin * 2));

    return ClipRRect(
      borderRadius: AppSpacing.borderRadiusLg,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.surface, accent.withValues(alpha: 0.06)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: accent.withValues(alpha: 0.25), width: 1.2),
          boxShadow: AppShadows.soft,
        ),
        child: Padding(
          padding: EdgeInsets.all(containerPadding),
          child: FittedBox(
            fit: BoxFit.contain,
            alignment: Alignment.center,
            child: SizedBox(
              width: gridDimension,
              height: gridDimension,
              child: CustomPaint(
                foregroundPainter: _PreviewWordPainter(
                  words: _words,
                  gridSize: previewSize,
                  color: accent,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    previewSize,
                    (row) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(previewSize, (col) {
                        final letter = _getRandomLetter(row, col);
                        final isPathCell = highlightedCells.contains(
                          _PreviewCell(row: row, col: col),
                        );

                        return Container(
                          width: baseCellSize,
                          height: baseCellSize,
                          margin: EdgeInsets.all(cellMargin),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(
                              color: AppColors.divider.withValues(alpha: 0.18),
                              width: 0.7,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              letter,
                              style: AppTypography.gridLetter.copyWith(
                                fontSize: math.max(4, baseCellSize * 0.5),
                                color: isPathCell
                                    ? accent.withValues(alpha: 0.85)
                                    : AppColors.textSecondary.withValues(
                                        alpha: 0.65,
                                      ),
                                fontWeight: isPathCell
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PreviewCell {
  const _PreviewCell({required this.row, required this.col});

  final int row;
  final int col;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _PreviewCell && row == other.row && col == other.col;

  @override
  int get hashCode => Object.hash(row, col);
}

class _PreviewWord {
  const _PreviewWord({
    required this.startRow,
    required this.startCol,
    required this.endRow,
    required this.endCol,
  });

  final int startRow;
  final int startCol;
  final int endRow;
  final int endCol;

  int get length {
    final dx = (endCol - startCol).abs();
    final dy = (endRow - startRow).abs();
    return math.max(dx, dy) + 1;
  }

  Offset get direction {
    final dx = (endCol - startCol).sign.toDouble();
    final dy = (endRow - startRow).sign.toDouble();
    return Offset(dx, dy);
  }

  double distanceTo(_PreviewWord other) {
    final startA = Offset(startCol.toDouble(), startRow.toDouble());
    final startB = Offset(other.startCol.toDouble(), other.startRow.toDouble());
    final endA = Offset(endCol.toDouble(), endRow.toDouble());
    final endB = Offset(other.endCol.toDouble(), other.endRow.toDouble());
    return (startA - startB).distance + (endA - endB).distance;
  }
}

class _PreviewWordPainter extends CustomPainter {
  _PreviewWordPainter({
    required this.words,
    required this.gridSize,
    required this.color,
  });

  final List<_PreviewWord> words;
  final int gridSize;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (gridSize == 0) return;

    final cellWidth = size.width / gridSize;
    final cellHeight = size.height / gridSize;

    for (final word in words) {
      final start = Offset(
        (word.startCol + 0.5) * cellWidth,
        (word.startRow + 0.5) * cellHeight,
      );
      final end = Offset(
        (word.endCol + 0.5) * cellWidth,
        (word.endRow + 0.5) * cellHeight,
      );

      final strokeWidth = math.max(3.0, cellWidth * 0.28);

      final shadowPaint = Paint()
        ..color = color.withValues(alpha: 0.1)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = strokeWidth + 3;

      final linePaint = Paint()
        ..color = color.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = strokeWidth;

      canvas.drawLine(start, end, shadowPaint);
      canvas.drawLine(start, end, linePaint);

      final markerPaint = Paint()
        ..color = color.withValues(alpha: 0.4)
        ..style = PaintingStyle.fill;

      final markerRadius = strokeWidth * 0.55;
      canvas.drawCircle(start, markerRadius, markerPaint);
      canvas.drawCircle(end, markerRadius, markerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _PreviewWordPainter oldDelegate) {
    return oldDelegate.words != words ||
        oldDelegate.gridSize != gridSize ||
        oldDelegate.color != color;
  }
}

