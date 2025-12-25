import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/breakpoints.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/entities/puzzle.dart';
import '../providers/game_providers.dart';
import '../../../daily/presentation/providers/daily_providers.dart';
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
    this.gameStateProvider,
  });

  final Difficulty difficulty;
  final WordCategory category;
  final GameMode gameMode;
  final AsyncGameStateNotifierProvider? gameStateProvider;

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
  double _currentMargin = 2.0; // Current margin between cells

  @override
  Widget build(BuildContext context) {
    // Use daily provider if in daily mode, otherwise use regular provider
    final AsyncValue<GameState> asyncGameState;
    final AsyncGameStateNotifierProvider? gameStateProvider;

    if (widget.gameMode == GameMode.daily) {
      // Use daily puzzle provider
      asyncGameState = ref.watch(dailyGameStateNotifierProvider);
      gameStateProvider = null; // Daily provider uses different notifier type
    } else {
      gameStateProvider =
          widget.gameStateProvider ??
          asyncGameStateNotifierProvider(
            difficulty: widget.difficulty,
            category: widget.category,
            gameMode: widget.gameMode,
          );
      asyncGameState = ref.watch(gameStateProvider);
    }

    // Handle loading/error states
    return asyncGameState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
      data: (gameState) => _buildGrid(
        context,
        gameState,
        gameStateProvider,
        widget.gameMode == GameMode.daily,
      ),
    );
  }

  Widget _buildGrid(
    BuildContext context,
    GameState gameState,
    AsyncGameStateNotifierProvider? gameStateProvider,
    bool isDailyMode,
  ) {
    final puzzle = gameState.puzzle;
    final selectedPath = gameState.selectedPath;
    final foundWords = gameState.foundWords;
    final hasError = gameState.hasError;
    final isCelebrating = gameState.isCelebrating;
    final hintedCell = gameState.hintedCell;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Available space from constraints (already accounts for parent padding)
        final availableWidth = constraints.maxWidth;
        final availableHeight = constraints.maxHeight;

        // Check if hard or medium mode in portrait for optimized layout
        final isPortrait = BreakpointUtils.isPortrait(context);
        final isHardPortrait =
            widget.difficulty == Difficulty.hard && isPortrait;
        final isMediumPortrait =
            widget.difficulty == Difficulty.medium && isPortrait;

        // Grid container has padding
        const padding = 4.0;
        // Reduced margin for hard/medium mode portrait (1px spacing between cells = 2px total)
        final margin = (isHardPortrait || isMediumPortrait) ? 0.5 : 2.0;

        // Update current margin for handlers
        if (_currentMargin != margin) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() => _currentMargin = margin);
            }
          });
        }

        const totalPadding = padding * 2;

        // Calculate space available for cells
        final cellAreaWidth = availableWidth - totalPadding;
        final cellAreaHeight = availableHeight - totalPadding;

        // Each cell takes (cellSize + margin*2) space
        // cellSize = (availableSpace / N) - margin*2
        final maxCellWidth = (cellAreaWidth / puzzle.size) - (margin * 2);
        final maxCellHeight = (cellAreaHeight / puzzle.size) - (margin * 2);

        // Use smaller dimension, floor to prevent overflow
        final cellSize = math
            .min(maxCellWidth, maxCellHeight)
            .floorToDouble()
            .clamp(20.0, 60.0);

        // Calculate actual grid size (will be <= available space)
        final gridSize = (cellSize + (margin * 2)) * puzzle.size + totalPadding;

        // Ensure it fits
        final constrainedGridSize = math.min(
          gridSize,
          math.min(availableWidth, availableHeight),
        );

        // Handle new word found - queue flash for after line animation
        if (gameState.lastFoundWord != null) {
          final wordToFlash = gameState.lastFoundWord!;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() => _pendingFlashWord = wordToFlash);
              _showWordFoundCelebration(wordToFlash, puzzle, _currentCellSize);
              // Clear lastFoundWord from state so we don't re-trigger
              if (isDailyMode) {
                ref
                    .read(dailyGameStateNotifierProvider.notifier)
                    .clearLastFoundWord();
              } else if (gameStateProvider != null) {
                ref.read(gameStateProvider.notifier).clearLastFoundWord();
              }
            }
          });
        }

        return Center(
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
                          _handlePointerDown(
                            event,
                            puzzle.size,
                            _currentCellSize,
                            _currentMargin,
                            isDailyMode,
                            gameStateProvider,
                          );
                        },
                        onPointerMove: (event) {
                          if (_isDragging) {
                            _handlePointerMove(
                              event,
                              puzzle.size,
                              _currentCellSize,
                              _currentMargin,
                              isDailyMode,
                              gameStateProvider,
                            );
                          }
                        },
                        onPointerUp: (event) {
                          _handlePointerUp(isDailyMode, gameStateProvider);
                        },
                        onPointerCancel: (event) {
                          _handlePointerUp(isDailyMode, gameStateProvider);
                        },
                        child: GestureDetector(
                          // Fallback for mobile
                          onPanStart: (details) {
                            _handlePanStart(
                              details,
                              puzzle.size,
                              _currentCellSize,
                              _currentMargin,
                              isDailyMode,
                              gameStateProvider,
                            );
                          },
                          onPanUpdate: (details) {
                            _handlePanUpdate(
                              details,
                              puzzle.size,
                              _currentCellSize,
                              _currentMargin,
                              isDailyMode,
                              gameStateProvider,
                            );
                          },
                          onPanEnd: (_) {
                            _handlePanEnd(isDailyMode, gameStateProvider);
                          },
                          child: Container(
                            width: constrainedGridSize,
                            height: constrainedGridSize,
                            decoration: BoxDecoration(
                              borderRadius: AppSpacing.borderRadiusMd,
                            ),
                            padding: const EdgeInsets.all(padding),
                            child: LayoutBuilder(
                              builder: (context, innerConstraints) {
                                // Calculate cell size to fit exactly within available space
                                final innerWidth = innerConstraints.maxWidth;
                                final innerHeight = innerConstraints.maxHeight;

                                // For N cells: totalSpace = N * (cellSize + margin*2)
                                // So: cellSize = (totalSpace / N) - margin*2
                                // Use floor to ensure we never exceed available space
                                final cellSizeFromWidth =
                                    (innerWidth / puzzle.size) - (margin * 2);
                                final cellSizeFromHeight =
                                    (innerHeight / puzzle.size) - (margin * 2);

                                // Use smaller dimension, floor to prevent overflow, cap at 60px max
                                final exactCellSize = math.min(
                                  cellSizeFromWidth,
                                  cellSizeFromHeight,
                                );
                                final finalCellSize = exactCellSize
                                    .floorToDouble()
                                    .clamp(16.0, 60.0);

                                // Update current cell size for handlers
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  if (mounted &&
                                      _currentCellSize != finalCellSize) {
                                    setState(
                                      () => _currentCellSize = finalCellSize,
                                    );
                                  }
                                });

                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    puzzle.size,
                                    (row) => Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                          hintedCell,
                                          finalCellSize,
                                          isHardPortrait,
                                          isMediumPortrait,
                                          margin,
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
                          margin: margin,
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
                            wordPosition: puzzle.getWordPosition(
                              _flashingWord!,
                            )!,
                            cellSize: _currentCellSize,
                            margin: margin,
                            onComplete: () {
                              setState(() => _flashingWord = null);
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                // Score popups (outside ClipRRect so they can overflow)
                ..._scorePopups.map(
                  (popup) => ScorePopup(
                    score: popup.score,
                    position: popup.position,
                    onComplete: () {
                      setState(() => _scorePopups.remove(popup));
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showWordFoundCelebration(String word, Puzzle puzzle, double cellSize) {
    // Get the word position from puzzle
    final wordPosition = puzzle.getWordPosition(word);
    if (wordPosition == null) return;

    // Calculate position for score popup (center of first cell)
    final firstCell = wordPosition.cells.first;
    const padding = 4.0;
    // Use current margin
    final margin = _currentMargin;
    const totalOffset = padding;
    final cellWithMargin = cellSize + (margin * 2);

    final x =
        totalOffset + (firstCell.$2 * cellWithMargin) + margin + (cellSize / 2);
    final y =
        totalOffset + (firstCell.$1 * cellWithMargin) + margin + (cellSize / 2);

    setState(() {
      _scorePopups.add(
        _ScorePopupData(
          score: AppConstants.basePointsPerWord,
          position: Offset(x, y),
        ),
      );
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
    (int, int)? hintedCell,
    double cellSize,
    bool isHardPortrait,
    bool isMediumPortrait,
    double margin,
  ) {
    final letter = puzzle.getLetter(row, col);
    final isSelected = selectedPath.contains((row, col));
    final isFound = _isCellFound(row, col, puzzle, foundWords);
    final isShaking = hasError && isSelected;
    final isHinted = hintedCell == (row, col);

    // Determine selection color - solid color for selection
    Color? selectionColor;
    if (isSelected) {
      selectionColor = AppColors.primary;
    }

    // Font size multipliers: hard = 0.6, medium = 0.55 (10% bigger), others = 0.5
    final fontSizeMultiplier = isHardPortrait
        ? 0.6
        : isMediumPortrait
        ? 0.55
        : 0.5;

    return Container(
      margin: EdgeInsets.all(margin),
      child: GridCell(
        letter: letter,
        row: row,
        col: col,
        isSelected: isSelected,
        isFound: isFound,
        isCelebrating: isCelebrating,
        isShaking: isShaking,
        isHinted: isHinted,
        selectionColor: selectionColor,
        cellSize: cellSize,
        fontSizeMultiplier: fontSizeMultiplier,
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

  // Helper methods to call the appropriate notifier based on mode
  void _startSelection(
    int row,
    int col,
    bool isDailyMode,
    AsyncGameStateNotifierProvider? provider,
  ) {
    if (isDailyMode) {
      ref
          .read(dailyGameStateNotifierProvider.notifier)
          .startSelection(row, col);
    } else if (provider != null) {
      ref.read(provider.notifier).startSelection(row, col);
    }
  }

  void _addToSelection(
    int row,
    int col,
    bool isDailyMode,
    AsyncGameStateNotifierProvider? provider,
  ) {
    if (isDailyMode) {
      ref
          .read(dailyGameStateNotifierProvider.notifier)
          .addToSelection(row, col);
    } else if (provider != null) {
      ref.read(provider.notifier).addToSelection(row, col);
    }
  }

  void _submitSelection(
    bool isDailyMode,
    AsyncGameStateNotifierProvider? provider,
  ) {
    if (isDailyMode) {
      ref.read(dailyGameStateNotifierProvider.notifier).submitSelection();
    } else if (provider != null) {
      ref.read(provider.notifier).submitSelection();
    }
  }

  void _handlePointerDown(
    PointerDownEvent event,
    int gridSize,
    double cellSize,
    double margin,
    bool isDailyMode,
    AsyncGameStateNotifierProvider? provider,
  ) {
    final position = _getCellPosition(
      event.localPosition,
      gridSize,
      cellSize,
      margin,
    );
    if (position != null) {
      setState(() {
        _isDragging = true;
        _lastCell = position;
      });
      _startSelection(position.$1, position.$2, isDailyMode, provider);
    }
  }

  void _handlePointerMove(
    PointerMoveEvent event,
    int gridSize,
    double cellSize,
    double margin,
    bool isDailyMode,
    AsyncGameStateNotifierProvider? provider,
  ) {
    if (!_isDragging) return;

    // Very sensitive - check all cells near the pointer
    final position = _getCellPosition(
      event.localPosition,
      gridSize,
      cellSize,
      margin,
    );
    if (position != null && position != _lastCell) {
      setState(() => _lastCell = position);
      _addToSelection(position.$1, position.$2, isDailyMode, provider);
    } else {
      // Check adjacent cells for very sensitive detection
      if (_lastCell != null) {
        final (lastRow, lastCol) = _lastCell!;
        for (int dr = -1; dr <= 1; dr++) {
          for (int dc = -1; dc <= 1; dc++) {
            if (dr == 0 && dc == 0) continue;
            final checkRow = lastRow + dr;
            final checkCol = lastCol + dc;
            if (checkRow >= 0 &&
                checkRow < gridSize &&
                checkCol >= 0 &&
                checkCol < gridSize) {
              final checkPos = _getCellPosition(
                event.localPosition,
                gridSize,
                cellSize,
                margin,
              );
              if (checkPos?.$1 == checkRow && checkPos?.$2 == checkCol) {
                setState(() => _lastCell = (checkRow, checkCol));
                _addToSelection(checkRow, checkCol, isDailyMode, provider);
                return;
              }
            }
          }
        }
      }
    }
  }

  void _handlePointerUp(
    bool isDailyMode,
    AsyncGameStateNotifierProvider? provider,
  ) {
    if (_isDragging) {
      setState(() {
        _isDragging = false;
        _lastCell = null;
      });
      _submitSelection(isDailyMode, provider);
    }
  }

  void _handlePanStart(
    DragStartDetails details,
    int gridSize,
    double cellSize,
    double margin,
    bool isDailyMode,
    AsyncGameStateNotifierProvider? provider,
  ) {
    final position = _getCellPosition(
      details.localPosition,
      gridSize,
      cellSize,
      margin,
    );
    if (position != null) {
      setState(() {
        _isDragging = true;
        _lastCell = position;
      });
      _startSelection(position.$1, position.$2, isDailyMode, provider);
    }
  }

  void _handlePanUpdate(
    DragUpdateDetails details,
    int gridSize,
    double cellSize,
    double margin,
    bool isDailyMode,
    AsyncGameStateNotifierProvider? provider,
  ) {
    if (!_isDragging) return;

    final position = _getCellPosition(
      details.localPosition,
      gridSize,
      cellSize,
      margin,
    );
    if (position != null && position != _lastCell) {
      setState(() => _lastCell = position);
      _addToSelection(position.$1, position.$2, isDailyMode, provider);
    }
  }

  void _handlePanEnd(
    bool isDailyMode,
    AsyncGameStateNotifierProvider? provider,
  ) {
    if (_isDragging) {
      setState(() {
        _isDragging = false;
        _lastCell = null;
      });
      _submitSelection(isDailyMode, provider);
    }
  }

  (int, int)? _getCellPosition(
    Offset localPosition,
    int gridSize,
    double cellSize,
    double margin,
  ) {
    // Account for padding
    const padding = 4.0; // Container padding
    const totalOffset = padding;

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
      if (cellX >= -margin &&
          cellX <= cellSize + margin * 3 &&
          cellY >= -margin &&
          cellY <= cellSize + margin * 3) {
        return (row, col);
      }
    }

    return null;
  }
}

class _ScorePopupData {
  _ScorePopupData({required this.score, required this.position});

  final int score;
  final Offset position;
}
