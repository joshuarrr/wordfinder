import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/entities/game_state.dart';
import '../providers/game_providers.dart';

/// Widget displaying the list of words to find
class WordListWidget extends ConsumerWidget {
  const WordListWidget({
    super.key,
    required this.difficulty,
    required this.category,
    required this.gameMode,
  });

  final Difficulty difficulty;
  final WordCategory category;
  final GameMode gameMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameStateProvider = asyncGameStateNotifierProvider(
      difficulty: difficulty,
      category: category,
      gameMode: gameMode,
    );
    
    final asyncGameState = ref.watch(gameStateProvider);
    
    return asyncGameState.when(
      loading: () => _buildLoadingContainer(),
      error: (e, st) => _buildErrorContainer(e),
      data: (gameState) => _buildWordList(gameState),
    );
  }

  Widget _buildLoadingContainer() {
    return Container(
      width: double.infinity,
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusLg,
        boxShadow: AppShadows.soft,
      ),
      child: Center(
        child: Text(
          'Loading words...',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textHint,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorContainer(Object error) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusLg,
        boxShadow: AppShadows.soft,
      ),
      child: Center(
        child: Text(
          'Error loading words',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.error,
          ),
        ),
      ),
    );
  }

  Widget _buildWordList(GameState gameState) {
    final puzzle = gameState.puzzle;
    final foundWords = gameState.foundWords;
    
    return Container(
      width: double.infinity,
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusLg,
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Words to Find',
                style: AppTypography.titleMedium,
              ),
              Text(
                '${foundWords.length}/${puzzle.words.length}',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          AppSpacing.vGapMd,
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
