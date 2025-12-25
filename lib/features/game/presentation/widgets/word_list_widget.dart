import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/theme.dart';
import '../../domain/entities/game_state.dart';

/// Widget displaying the list of words to find
class WordListWidget extends StatelessWidget {
  const WordListWidget({
    super.key,
    required this.gameState,
  });

  final GameState gameState;

  @override
  Widget build(BuildContext context) {
    final puzzle = gameState.puzzle;
    final foundWords = gameState.foundWords;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Words to find header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Words to Find',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '${foundWords.length}/${puzzle.words.length}',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        AppSpacing.vGapSm,
        Expanded(
          child: puzzle.words.isEmpty
              ? Center(
                  child: Text(
                    'Loading words...',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textHint,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: () {
                      // Sort words alphabetically
                      final wordList = puzzle.words.map((wp) => wp.word).toList()..sort();
                      return wordList.map((word) {
                        final isFound = foundWords.contains(word);
                        return _WordChip(
                          word: word,
                          isFound: isFound,
                          key: ValueKey(word),
                        )
                            .animate(key: ValueKey('${word}_$isFound'))
                            .fadeIn(duration: 200.ms)
                            .then(delay: isFound ? 0.ms : 0.ms)
                            .scale(
                              begin: const Offset(1, 1),
                              end: isFound ? const Offset(0.95, 0.95) : const Offset(1, 1),
                              duration: 300.ms,
                              curve: Curves.easeOutCubic,
                            );
                      }).toList();
                    }(),
                  ),
                ),
        ),
      ],
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
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isFound
            ? AppColors.success.withValues(alpha: 0.1)
            : AppColors.surfaceVariant,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(
          color: isFound ? AppColors.success : AppColors.divider,
          width: isFound ? 2 : 1,
        ),
      ),
      child: Text(
        word,
        style: isFound
            ? AppTypography.wordListItemFound
            : AppTypography.wordListItem,
      ),
    );
  }
}
