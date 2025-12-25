// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedPreferencesHash() => r'eceb0a339573ab7e50e2f0d6b3b774ac2eb4b45a';

/// Provider for SharedPreferences instance
/// Using keepAlive to ensure consistent instance across app lifecycle
///
/// Copied from [sharedPreferences].
@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = FutureProvider<SharedPreferences>.internal(
  sharedPreferences,
  name: r'sharedPreferencesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sharedPreferencesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SharedPreferencesRef = FutureProviderRef<SharedPreferences>;
String _$localScoreDataSourceHash() =>
    r'4970446042824e06aaf60307103db874dfb46eb6';

/// Provider for LocalScoreDataSource
///
/// Copied from [localScoreDataSource].
@ProviderFor(localScoreDataSource)
final localScoreDataSourceProvider =
    AutoDisposeFutureProvider<LocalScoreDataSource>.internal(
      localScoreDataSource,
      name: r'localScoreDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$localScoreDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LocalScoreDataSourceRef =
    AutoDisposeFutureProviderRef<LocalScoreDataSource>;
String _$scoreRepositoryHash() => r'52c5b335d553b747cc865c66e6550635322ab8a6';

/// Provider for ScoreRepository
///
/// Copied from [scoreRepository].
@ProviderFor(scoreRepository)
final scoreRepositoryProvider =
    AutoDisposeFutureProvider<ScoreRepository>.internal(
      scoreRepository,
      name: r'scoreRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$scoreRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ScoreRepositoryRef = AutoDisposeFutureProviderRef<ScoreRepository>;
String _$cumulativeScoreHash() => r'2cd946a322efea765300a383422ad5ae2c1d9f9f';

/// Provider for cumulative score
/// Using keepAlive to ensure it persists and can be properly refreshed
///
/// Copied from [cumulativeScore].
@ProviderFor(cumulativeScore)
final cumulativeScoreProvider = FutureProvider<int>.internal(
  cumulativeScore,
  name: r'cumulativeScoreProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cumulativeScoreHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CumulativeScoreRef = FutureProviderRef<int>;
String _$scoreStatsHash() => r'dee2d71ee039cb55643aea1dbc8610331c244997';

/// Provider for all score statistics
///
/// Copied from [scoreStats].
@ProviderFor(scoreStats)
final scoreStatsProvider = AutoDisposeFutureProvider<ScoreStats>.internal(
  scoreStats,
  name: r'scoreStatsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$scoreStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ScoreStatsRef = AutoDisposeFutureProviderRef<ScoreStats>;
String _$highScoreHash() => r'e629283f33f003a30bc0fda068ac65455a0da6d7';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provider for high score by difficulty
///
/// Copied from [highScore].
@ProviderFor(highScore)
const highScoreProvider = HighScoreFamily();

/// Provider for high score by difficulty
///
/// Copied from [highScore].
class HighScoreFamily extends Family<AsyncValue<int?>> {
  /// Provider for high score by difficulty
  ///
  /// Copied from [highScore].
  const HighScoreFamily();

  /// Provider for high score by difficulty
  ///
  /// Copied from [highScore].
  HighScoreProvider call(Difficulty difficulty) {
    return HighScoreProvider(difficulty);
  }

  @override
  HighScoreProvider getProviderOverride(covariant HighScoreProvider provider) {
    return call(provider.difficulty);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'highScoreProvider';
}

/// Provider for high score by difficulty
///
/// Copied from [highScore].
class HighScoreProvider extends AutoDisposeFutureProvider<int?> {
  /// Provider for high score by difficulty
  ///
  /// Copied from [highScore].
  HighScoreProvider(Difficulty difficulty)
    : this._internal(
        (ref) => highScore(ref as HighScoreRef, difficulty),
        from: highScoreProvider,
        name: r'highScoreProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$highScoreHash,
        dependencies: HighScoreFamily._dependencies,
        allTransitiveDependencies: HighScoreFamily._allTransitiveDependencies,
        difficulty: difficulty,
      );

  HighScoreProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.difficulty,
  }) : super.internal();

  final Difficulty difficulty;

  @override
  Override overrideWith(FutureOr<int?> Function(HighScoreRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: HighScoreProvider._internal(
        (ref) => create(ref as HighScoreRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        difficulty: difficulty,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<int?> createElement() {
    return _HighScoreProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HighScoreProvider && other.difficulty == difficulty;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, difficulty.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HighScoreRef on AutoDisposeFutureProviderRef<int?> {
  /// The parameter `difficulty` of this provider.
  Difficulty get difficulty;
}

class _HighScoreProviderElement extends AutoDisposeFutureProviderElement<int?>
    with HighScoreRef {
  _HighScoreProviderElement(super.provider);

  @override
  Difficulty get difficulty => (origin as HighScoreProvider).difficulty;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
