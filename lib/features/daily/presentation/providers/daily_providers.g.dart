// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$localDailyDataSourceHash() =>
    r'8611d57a22d395f06b88c35d60a580c9df0cec76';

/// Provider for LocalDailyDataSource
///
/// Copied from [localDailyDataSource].
@ProviderFor(localDailyDataSource)
final localDailyDataSourceProvider =
    AutoDisposeFutureProvider<LocalDailyDataSource>.internal(
      localDailyDataSource,
      name: r'localDailyDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$localDailyDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LocalDailyDataSourceRef =
    AutoDisposeFutureProviderRef<LocalDailyDataSource>;
String _$dailyRepositoryHash() => r'77cc5049feec9a0b6cd65a5c950d28778e2405a2';

/// Provider for DailyRepository
///
/// Copied from [dailyRepository].
@ProviderFor(dailyRepository)
final dailyRepositoryProvider =
    AutoDisposeFutureProvider<DailyRepository>.internal(
      dailyRepository,
      name: r'dailyRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dailyRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DailyRepositoryRef = AutoDisposeFutureProviderRef<DailyRepository>;
String _$dailyStreakHash() => r'8dc0b3683feb74f8a5b97a3ae4274e776bc1ffcc';

/// Provider for current daily streak
///
/// Copied from [dailyStreak].
@ProviderFor(dailyStreak)
final dailyStreakProvider = AutoDisposeFutureProvider<int>.internal(
  dailyStreak,
  name: r'dailyStreakProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dailyStreakHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DailyStreakRef = AutoDisposeFutureProviderRef<int>;
String _$dailyStatsHash() => r'b988a7009c92243f986140a335d1506f8b723bf4';

/// Provider for daily puzzle stats
///
/// Copied from [dailyStats].
@ProviderFor(dailyStats)
final dailyStatsProvider = AutoDisposeFutureProvider<DailyPuzzleStats>.internal(
  dailyStats,
  name: r'dailyStatsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dailyStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DailyStatsRef = AutoDisposeFutureProviderRef<DailyPuzzleStats>;
String _$isTodayPuzzleCompletedHash() =>
    r'6c6d34623753e39e3a402a05ff5f5d8bef7a7c38';

/// Provider for checking if today's puzzle is completed
///
/// Copied from [isTodayPuzzleCompleted].
@ProviderFor(isTodayPuzzleCompleted)
final isTodayPuzzleCompletedProvider = AutoDisposeFutureProvider<bool>.internal(
  isTodayPuzzleCompleted,
  name: r'isTodayPuzzleCompletedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isTodayPuzzleCompletedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsTodayPuzzleCompletedRef = AutoDisposeFutureProviderRef<bool>;
String _$todayCategoryHash() => r'dc278d00c59a4e280bc935d044756b18253f4f38';

/// Provider for today's category
///
/// Copied from [todayCategory].
@ProviderFor(todayCategory)
final todayCategoryProvider = AutoDisposeProvider<WordCategory>.internal(
  todayCategory,
  name: r'todayCategoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todayCategoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayCategoryRef = AutoDisposeProviderRef<WordCategory>;
String _$todayProgressHash() => r'c71ff39ca9555eb4aabacabd1a8eff3e71deae11';

/// Provider for today's puzzle progress
///
/// Copied from [todayProgress].
@ProviderFor(todayProgress)
final todayProgressProvider =
    AutoDisposeFutureProvider<DailyPuzzleProgress?>.internal(
      todayProgress,
      name: r'todayProgressProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$todayProgressHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayProgressRef = AutoDisposeFutureProviderRef<DailyPuzzleProgress?>;
String _$dailyGameStateNotifierHash() =>
    r'271557d5a4409bd0d4cb86cfc5415fd2290a51aa';

/// Async notifier for daily puzzle game state
///
/// Copied from [DailyGameStateNotifier].
@ProviderFor(DailyGameStateNotifier)
final dailyGameStateNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      DailyGameStateNotifier,
      GameState
    >.internal(
      DailyGameStateNotifier.new,
      name: r'dailyGameStateNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dailyGameStateNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DailyGameStateNotifier = AutoDisposeAsyncNotifier<GameState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
