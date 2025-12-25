import 'package:flutter/material.dart';

/// Represents a word's position and direction in the grid
class WordPosition {
  const WordPosition({
    required this.word,
    required this.startRow,
    required this.startCol,
    required this.direction,
  });

  final String word;
  final int startRow;
  final int startCol;
  final (int, int) direction; // (rowDelta, colDelta)

  /// Get all cell positions for this word
  List<(int, int)> get cells {
    final positions = <(int, int)>[];
    final (rowDelta, colDelta) = direction;
    
    for (int i = 0; i < word.length; i++) {
      positions.add((
        startRow + (rowDelta * i),
        startCol + (colDelta * i),
      ));
    }
    
    return positions;
  }

  /// Get the line path for drawing
  Path getLinePath(double cellSize, double margin) {
    final path = Path();
    final (rowDelta, colDelta) = direction;
    
    // Calculate start and end positions (cell centers)
    final start = _getCellCenter(startRow, startCol, cellSize, margin);
    final endRow = startRow + (rowDelta * (word.length - 1));
    final endCol = startCol + (colDelta * (word.length - 1));
    final end = _getCellCenter(endRow, endCol, cellSize, margin);
    
    path.moveTo(start.dx, start.dy);
    path.lineTo(end.dx, end.dy);
    
    return path;
  }

  /// Get the center point of a cell
  Offset _getCellCenter(int row, int col, double cellSize, double margin) {
    const padding = 4.0; // Container padding
    const totalOffset = padding;
    
    final cellWithMargin = cellSize + (margin * 2);
    final x = totalOffset + (col * cellWithMargin) + margin + (cellSize / 2);
    final y = totalOffset + (row * cellWithMargin) + margin + (cellSize / 2);
    
    return Offset(x, y);
  }

  /// Check if a path matches this word position
  bool matchesPath(List<(int, int)> path) {
    if (path.length != word.length) return false;
    
    final cells = this.cells;
    // Check both forward and reverse
    final matchesForward = _listsEqual(path, cells);
    final matchesReverse = _listsEqual(path, cells.reversed.toList());
    
    return matchesForward || matchesReverse;
  }

  bool _listsEqual(List<(int, int)> a, List<(int, int)> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].$1 != b[i].$1 || a[i].$2 != b[i].$2) {
        return false;
      }
    }
    return true;
  }

  @override
  String toString() => 'WordPosition($word, ($startRow, $startCol), $direction)';
}
