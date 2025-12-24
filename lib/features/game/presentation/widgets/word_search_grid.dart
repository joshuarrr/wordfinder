import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/entities/puzzle.dart';
import '../providers/game_providers.dart';
import 'found_word_overlay.dart';
import 'score_popup.dart';
import 'word_found_animation.dart';

/// Interactive word search grid widget
class WordSearchGrid extends ConsumerStatefulWidget {
  const WordSearchGrid({
    super.key,
    required this.difficulty,
    required this.category,
    required this.gameMode,
  });

  final Difficulty difficulty;
  final WordCategory category;
  final GameMode gameMode;

  @override
  ConsumerState<WordSearchGrid> createState() => _WordSearchGridState();
}

class _WordSearchGridState extends ConsumerState<WordSearchGrid> {
  bool _isDragging = false;
  (int, int)? _lastCell;
  final List<_ScorePopupData> _scorePopups = [];
  String? _flashingWord;
  String? _pendingFlashWord; // Word waiting for line animation to complete
  double _currentCellSize = 40.0; // Default, will be updated

  @override
  Widget build(BuildContext context) {
    final gameStateProvider = asyncGameStateNotifierProvider(
      difficulty: widget.difficulty,
      category: widget.category,
      gameMode: widget.gameMode,
    );
    
    final asyncGameState = ref.watch(gameStateProvider);
    
    // Handle loading/error states
    return asyncGameState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
      data: (gameState) => _buildGrid(context, gameState, gameStateProvider),
    );
  }

  Widget _buildGrid(
    BuildContext context,
    GameState gameState,
    AsyncGameStateNotifierProvider gameStateProvider,
  ) {
    final puzzle = gameState.puzzle;
    final selectedPath = gameState.selectedPath;
    final foundWords = gameState.foundWords;
    final hasError = gameState.hasError;
    final isCelebrating = gameState.isCelebrating;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate cell size based on available space (both width and height)
        // Account for outer container padding
        final availableWidth = constraints.maxWidth - (AppSpacing.md * 2);
        final availableHeight = constraints.maxHeight - (AppSpacing.md * 2);
        
        // Account for padding and borders inside the grid container
        const padding = 4.0;
        const border = 2.0;
        const margin = 2.0; // Margin on each side of cell
        const totalPadding = (padding + border) * 2;
        
        // Calculate available space for cells (after padding/border)
        final cellAreaWidth = availableWidth - totalPadding;
        final cellAreaHeight = availableHeight - totalPadding;
        
        // For N cells with margins: each cell takes (cellSize + margin*2) space
        // Total space needed = N * (cellSize + margin*2) - margin*2 (last cell doesn't need trailing margin)
        // Simplified: N * cellSize + (N-1) * margin*2 + margin*2 = N * cellSize + N * margin*2
        // So: availableSpace = N * (cellSize + margin*2)
        // Therefore: cellSize = (availableSpace / N) - margin*2
        
        final maxCellWidth = (cellAreaWidth / puzzle.size) - (margin * 2);
        final maxCellHeight = (cellAreaHeight / puzzle.size) - (margin * 2);
        
        // Use the smaller dimension to ensure grid fits
        final cellSize = math.min(maxCellWidth, maxCellHeight)
            .clamp(24.0, 60.0); // Minimum 24px for readability
        
        // Calculate actual grid size
        // Total = (cellSize + margin*2) * N + padding + border
        final gridSize = (cellSize + (margin * 2)) * puzzle.size + totalPadding;
        
        // Ensure gridSize doesn't exceed available space
        final constrainedGridSize = math.min(
          math.min(gridSize, availableWidth),
          math.min(gridSize, availableHeight),
        );
        
        // Handle new word found - queue flash for after line animation
        if (gameState.lastFoundWord != null) {
          final wordToFlash = gameState.lastFoundWord!;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() => _pendingFlashWord = wordToFlash);
              _showWordFoundCelebration(wordToFlash, puzzle, _currentCellSize);
              // Clear lastFoundWord from state so we don't re-trigger
              ref.read(gameStateProvider.notifier).clearLastFoundWord();
            }
          });
        }

        return Container(
          padding: AppSpacing.paddingMd,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: AppSpacing.borderRadiusLg,
          ),
          child: Center(
            child: SizedBox(
              width: constrainedGridSize,
              height: constrainedGridSize,
              // Outer stack with no clipping for score popups
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Grid with clipping
                  ClipRRect(
                    borderRadius: AppSpacing.borderRadiusMd,
                    child: Stack(
                      children: [
                        // Grid
                        Listener(
                          onPointerDown: (event) {
                            _handlePointerDown(event, puzzle.size, _currentCellSize, gameStateProvider);
                          },
                          onPointerMove: (event) {
                            if (_isDragging) {
                              _handlePointerMove(event, puzzle.size, _currentCellSize, gameStateProvider);
                            }
                          },
                          onPointerUp: (event) {
                            _handlePointerUp(gameStateProvider);
                          },
                          onPointerCancel: (event) {
                            _handlePointerUp(gameStateProvider);
                          },
                          child: GestureDetector(
                            // Fallback for mobile
                            onPanStart: (details) {
                              _handlePanStart(details, puzzle.size, _currentCellSize, gameStateProvider);
                            },
                            onPanUpdate: (details) {
                              _handlePanUpdate(details, puzzle.size, _currentCellSize, gameStateProvider);
                            },
                            onPanEnd: (_) {
                              _handlePanEnd(gameStateProvider);
                            },
                            child: Container(
                              width: constrainedGridSize,
                              height: constrainedGridSize,
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: AppSpacing.borderRadiusMd,
                                border: Border.all(color: AppColors.gridLine, width: 2),
                              ),
                              padding: const EdgeInsets.all(padding),
                              child: LayoutBuilder(
                                builder: (context, innerConstraints) {
                                  // Calculate cell size based on inner constraints
                                  final innerWidth = innerConstraints.maxWidth;
                                  final innerHeight = innerConstraints.maxHeight;
                                  final cellArea = math.min(innerWidth, innerHeight);
                                  
                                  // Recalculate cell size to fit exactly
                                  // For N cells: cellArea = N * (cellSize + margin*2)
                                  // So: cellSize = (cellArea / N) - margin*2
                                  final exactCellSize = (cellArea / puzzle.size) - (margin * 2);
                                  final finalCellSize = exactCellSize.clamp(24.0, 60.0);
                                  
                                  // Update current cell size for handlers
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    if (mounted && _currentCellSize != finalCellSize) {
                                      setState(() => _currentCellSize = finalCellSize);
                                    }
                                  });
                                  
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: List.generate(
                                      puzzle.size,
                                      (row) => Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: List.generate(
                                          puzzle.size,
                                          (col) => _buildCell(
                                            row,
                                            col,
                                            puzzle,
                                            selectedPath,
                                            foundWords,
                                            hasError,
                                            isCelebrating,
                                            finalCellSize,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        // Found word overlay (lines)
                        Positioned.fill(
                          child: FoundWordOverlay(
                            puzzle: puzzle,
                            foundWords: foundWords,
                            cellSize: _currentCellSize,
                            onAnimationComplete: () {
                              // After line animation, trigger the flash
                              if (_pendingFlashWord != null && mounted) {
                                setState(() {
                                  _flashingWord = _pendingFlashWord;
                                  _pendingFlashWord = null;
                                });
                              }
                            },
                          ),
                        ),
                        // Flash animation for newly found word
                        if (_flashingWord != null)
                          Positioned.fill(
                            child: WordFoundAnimation(
                              wordPosition: puzzle.getWordPosition(_flashingWord!)!,
                              cellSize: _currentCellSize,
                              onComplete: () {
                                setState(() => _flashingWord = null);
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Score popups (outside ClipRRect so they can overflow)
                  ..._scorePopups.map((popup) => ScorePopup(
                    score: popup.score,
                    position: popup.position,
                    onComplete: () {
                      setState(() => _scorePopups.remove(popup));
                    },
                  )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showWordFoundCelebration(
    String word,
    Puzzle puzzle,
    double cellSize,
  ) {
    // Get the word position from puzzle
    final wordPosition = puzzle.getWordPosition(word);
    if (wordPosition == null) return;
    
    // Calculate position for score popup (center of first cell)
    final firstCell = wordPosition.cells.first;
    const padding = 4.0;
    const border = 2.0;
    const margin = 2.0;
    const totalOffset = padding + border;
    final cellWithMargin = cellSize + (margin * 2);
    
    final x = totalOffset + (firstCell.$2 * cellWithMargin) + margin + (cellSize / 2);
    final y = totalOffset + (firstCell.$1 * cellWithMargin) + margin + (cellSize / 2);
    
    setState(() {
      _scorePopups.add(_ScorePopupData(
        score: AppConstants.basePointsPerWord,
        position: Offset(x, y),
      ));
    });
  }

  Widget _buildCell(
    int row,
    int col,
    Puzzle puzzle,
    List<(int, int)> selectedPath,
    Set<String> foundWords,
    bool hasError,
    bool isCelebrating,
    double cellSize,
  ) {
    final letter = puzzle.getLetter(row, col);
    final isSelected = selectedPath.contains((row, col));
    final isFound = _isCellFound(row, col, puzzle, foundWords);
    final isShaking = hasError && isSelected;
    
    // Determine selection color - solid color for selection
    Color? selectionColor;
    if (isSelected) {
      selectionColor = AppColors.primary;
    }

    return Container(
      margin: const EdgeInsets.all(2),
      child: GridCell(
        letter: letter,
        row: row,
        col: col,
        isSelected: isSelected,
        isFound: isFound,
        isCelebrating: isCelebrating,
        isShaking: isShaking,
        selectionColor: selectionColor,
        cellSize: cellSize,
      ),
    );
  }

  bool _isCellFound(int row, int col, Puzzle puzzle, Set<String> foundWords) {
    for (final wordPos in puzzle.words) {
      if (foundWords.contains(wordPos.word)) {
        if (wordPos.cells.contains((row, col))) {
          return true;
        }
      }
    }
    return false;
  }

  void _handlePointerDown(
    PointerDownEvent event,
    int gridSize,
    double cellSize,
    AsyncGameStateNotifierProvider provider,
  ) {
    final position = _getCellPosition(event.localPosition, gridSize, cellSize);
    if (position != null) {
      setState(() {
        _isDragging = true;
        _lastCell = position;
      });
      ref.read(provider.notifier).startSelection(position.$1, position.$2);
    }
  }

  void _handlePointerMove(
    PointerMoveEvent event,
    int gridSize,
    double cellSize,
    AsyncGameStateNotifierProvider provider,
  ) {
    if (!_isDragging) return;
    
    // Very sensitive - check all cells near the pointer
    final position = _getCellPosition(event.localPosition, gridSize, cellSize);
    if (position != null && position != _lastCell) {
      setState(() => _lastCell = position);
      ref.read(provider.notifier).addToSelection(position.$1, position.$2);
    } else {
      // Check adjacent cells for very sensitive detection
      if (_lastCell != null) {
        final (lastRow, lastCol) = _lastCell!;
        for (int dr = -1; dr <= 1; dr++) {
          for (int dc = -1; dc <= 1; dc++) {
            if (dr == 0 && dc == 0) continue;
            final checkRow = lastRow + dr;
            final checkCol = lastCol + dc;
            if (checkRow >= 0 && checkRow < gridSize && 
                checkCol >= 0 && checkCol < gridSize) {
              final checkPos = _getCellPosition(
                event.localPosition,
                gridSize,
                cellSize,
              );
              if (checkPos?.$1 == checkRow && checkPos?.$2 == checkCol) {
                setState(() => _lastCell = (checkRow, checkCol));
                ref.read(provider.notifier).addToSelection(checkRow, checkCol);
                return;
              }
            }
          }
        }
      }
    }
  }

  void _handlePointerUp(AsyncGameStateNotifierProvider provider) {
    if (_isDragging) {
      setState(() {
        _isDragging = false;
        _lastCell = null;
      });
      ref.read(provider.notifier).submitSelection();
    }
  }

  void _handlePanStart(
    DragStartDetails details,
    int gridSize,
    double cellSize,
    AsyncGameStateNotifierProvider provider,
  ) {
    final position = _getCellPosition(details.localPosition, gridSize, cellSize);
    if (position != null) {
      setState(() {
        _isDragging = true;
        _lastCell = position;
      });
      ref.read(provider.notifier).startSelection(position.$1, position.$2);
    }
  }

  void _handlePanUpdate(
    DragUpdateDetails details,
    int gridSize,
    double cellSize,
    AsyncGameStateNotifierProvider provider,
  ) {
    if (!_isDragging) return;
    
    final position = _getCellPosition(details.localPosition, gridSize, cellSize);
    if (position != null && position != _lastCell) {
      setState(() => _lastCell = position);
      ref.read(provider.notifier).addToSelection(position.$1, position.$2);
    }
  }

  void _handlePanEnd(AsyncGameStateNotifierProvider provider) {
    if (_isDragging) {
      setState(() {
        _isDragging = false;
        _lastCell = null;
      });
      ref.read(provider.notifier).submitSelection();
    }
  }

  (int, int)? _getCellPosition(Offset localPosition, int gridSize, double cellSize) {
    // Account for padding and border
    const padding = 4.0; // Container padding
    const border = 2.0; // Border width
    const margin = 2.0; // Cell margin on each side
    const totalOffset = padding + border;
    
    final adjustedX = localPosition.dx - totalOffset;
    final adjustedY = localPosition.dy - totalOffset;
    
    if (adjustedX < 0 || adjustedY < 0) return null;
    
    // Each cell takes up cellSize + (margin * 2) space
    final cellWithMargin = cellSize + (margin * 2);
    final col = (adjustedX / cellWithMargin).floor();
    final row = (adjustedY / cellWithMargin).floor();
    
    // Check bounds - very sensitive, allow margin area
    if (row >= 0 && row < gridSize && col >= 0 && col < gridSize) {
      // Very sensitive - accept clicks even in margin area
      final cellX = adjustedX - (col * cellWithMargin);
      final cellY = adjustedY - (row * cellWithMargin);
      
      // Accept if anywhere near the cell (including margins)
      if (cellX >= -margin && cellX <= cellSize + margin * 3 &&
          cellY >= -margin && cellY <= cellSize + margin * 3) {
        return (row, col);
      }
    }
    
    return null;
  }
}

class _ScorePopupData {
  _ScorePopupData({
    required this.score,
    required this.position,
  });

  final int score;
  final Offset position;
}
