import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/theme.dart';
import '../../domain/entities/game_state.dart';

/// Footer showing word count and word chips
class GameFooter extends StatelessWidget {
  const GameFooter({
    super.key,
    required this.gameState,
    this.onHintPressed,
    this.hintsRemaining = 0,
  });

  final GameState gameState;
  final VoidCallback? onHintPressed;
  final int hintsRemaining;

  @override
  Widget build(BuildContext context) {
    final puzzle = gameState.puzzle;
    final foundWords = gameState.foundWords;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.divider, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: count + "Words to find" + help button
            Row(
              children: [
                Text(
                  '${foundWords.length}/${puzzle.words.length}',
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Words to find',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                if (onHintPressed != null)
                  GestureDetector(
                    onTap: hintsRemaining > 0 ? onHintPressed : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: hintsRemaining > 0
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: hintsRemaining > 0
                              ? AppColors.primary
                              : AppColors.divider,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.lightbulb_outline_rounded,
                            size: 16,
                            color: hintsRemaining > 0
                                ? AppColors.primary
                                : AppColors.textHint,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$hintsRemaining',
                            style: AppTypography.labelMedium.copyWith(
                              color: hintsRemaining > 0
                                  ? AppColors.primary
                                  : AppColors.textHint,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            // Divider
            Container(
              height: 1,
              color: AppColors.divider,
            ),
            const SizedBox(height: 8),
            // Word chips - flexible height (expands in sidebar, fixed in footer)
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: () {
                    final wordList = puzzle.words.map((wp) => wp.word).toList()
                      ..sort();
                    return wordList.map((word) {
                      final isFound = foundWords.contains(word);
                      return _WordChip(
                        word: word,
                        isFound: isFound,
                        key: ValueKey(word),
                      )
                          .animate(key: ValueKey('${word}_$isFound'))
                          .fadeIn(duration: 200.ms);
                    }).toList();
                  }(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WordChip extends StatelessWidget {
  const _WordChip({
    super.key,
    required this.word,
    required this.isFound,
  });

  final String word;
  final bool isFound;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: isFound
            ? AppColors.success.withValues(alpha: 0.1)
            : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isFound ? AppColors.success : AppColors.divider,
          width: 1,
        ),
      ),
      child: Text(
        word,
        style: AppTypography.labelSmall.copyWith(
          fontWeight: FontWeight.w500,
          color: isFound ? AppColors.success : AppColors.textPrimary,
          decoration: isFound ? TextDecoration.lineThrough : null,
        ),
      ),
    );
  }
}

