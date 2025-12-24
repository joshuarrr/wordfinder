/// Utility functions for formatting scores
class ScoreFormatter {
  /// Format score with commas (e.g., 1234 -> "1,234")
  static String formatScore(int score) {
    return score.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  /// Format score in compact form (e.g., 1234 -> "1.2K")
  static String formatScoreCompact(int score) {
    if (score < 1000) {
      return score.toString();
    } else if (score < 1000000) {
      final thousands = score / 1000.0;
      return '${thousands.toStringAsFixed(thousands.truncateToDouble() == thousands ? 0 : 1)}K';
    } else {
      final millions = score / 1000000.0;
      return '${millions.toStringAsFixed(millions.truncateToDouble() == millions ? 0 : 1)}M';
    }
  }

  /// Format score change (e.g., 450 -> "+450")
  static String formatScoreChange(int change) {
    if (change > 0) {
      return '+${formatScore(change)}';
    } else if (change < 0) {
      return formatScore(change);
    } else {
      return '0';
    }
  }
}

