import '../../core/constants/app_constants.dart';
import 'animals.dart';
import 'food.dart';
import 'countries.dart';
import 'sports.dart';
import 'nature.dart';
import 'science.dart';
import 'movies.dart';
import 'holidays.dart';

/// Word lists for each category
class WordLists {
  static List<String> getWordsForCategory(WordCategory category) {
    return switch (category) {
      WordCategory.animals => animals,
      WordCategory.food => food,
      WordCategory.countries => countries,
      WordCategory.sports => sports,
      WordCategory.nature => nature,
      WordCategory.science => science,
      WordCategory.movies => movies,
      WordCategory.holidays => holidays,
    };
  }

  /// Get a random subset of words for a given difficulty
  static List<String> getRandomWords(WordCategory category, int count) {
    final allWords = getWordsForCategory(category);
    final shuffled = List<String>.from(allWords)..shuffle();
    return shuffled.take(count).toList();
  }
}
