// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$puzzleGeneratorHash() => r'6baac8fdaadebf9fe9f5c53f1f2bd766390b28eb';

/// Provider for puzzle generator
///
/// Copied from [puzzleGenerator].
@ProviderFor(puzzleGenerator)
final puzzleGeneratorProvider = AutoDisposeProvider<PuzzleGenerator>.internal(
  puzzleGenerator,
  name: r'puzzleGeneratorProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$puzzleGeneratorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PuzzleGeneratorRef = AutoDisposeProviderRef<PuzzleGenerator>;
String _$puzzleAsyncHash() => r'ed248698cb8e1accd3c9583b84488731585e094b';

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

/// Async provider for puzzle generation - runs in isolate to avoid blocking UI
///
/// Copied from [puzzleAsync].
@ProviderFor(puzzleAsync)
const puzzleAsyncProvider = PuzzleAsyncFamily();

/// Async provider for puzzle generation - runs in isolate to avoid blocking UI
///
/// Copied from [puzzleAsync].
class PuzzleAsyncFamily extends Family<AsyncValue<Puzzle>> {
  /// Async provider for puzzle generation - runs in isolate to avoid blocking UI
  ///
  /// Copied from [puzzleAsync].
  const PuzzleAsyncFamily();

  /// Async provider for puzzle generation - runs in isolate to avoid blocking UI
  ///
  /// Copied from [puzzleAsync].
  PuzzleAsyncProvider call({
    required Difficulty difficulty,
    required WordCategory category,
    required GameMode gameMode,
  }) {
    return PuzzleAsyncProvider(
      difficulty: difficulty,
      category: category,
      gameMode: gameMode,
    );
  }

  @override
  PuzzleAsyncProvider getProviderOverride(
    covariant PuzzleAsyncProvider provider,
  ) {
    return call(
      difficulty: provider.difficulty,
      category: provider.category,
      gameMode: provider.gameMode,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'puzzleAsyncProvider';
}

/// Async provider for puzzle generation - runs in isolate to avoid blocking UI
///
/// Copied from [puzzleAsync].
class PuzzleAsyncProvider extends AutoDisposeFutureProvider<Puzzle> {
  /// Async provider for puzzle generation - runs in isolate to avoid blocking UI
  ///
  /// Copied from [puzzleAsync].
  PuzzleAsyncProvider({
    required Difficulty difficulty,
    required WordCategory category,
    required GameMode gameMode,
  }) : this._internal(
         (ref) => puzzleAsync(
           ref as PuzzleAsyncRef,
           difficulty: difficulty,
           category: category,
           gameMode: gameMode,
         ),
         from: puzzleAsyncProvider,
         name: r'puzzleAsyncProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$puzzleAsyncHash,
         dependencies: PuzzleAsyncFamily._dependencies,
         allTransitiveDependencies:
             PuzzleAsyncFamily._allTransitiveDependencies,
         difficulty: difficulty,
         category: category,
         gameMode: gameMode,
       );

  PuzzleAsyncProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.difficulty,
    required this.category,
    required this.gameMode,
  }) : super.internal();

  final Difficulty difficulty;
  final WordCategory category;
  final GameMode gameMode;

  @override
  Override overrideWith(
    FutureOr<Puzzle> Function(PuzzleAsyncRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PuzzleAsyncProvider._internal(
        (ref) => create(ref as PuzzleAsyncRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        difficulty: difficulty,
        category: category,
        gameMode: gameMode,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Puzzle> createElement() {
    return _PuzzleAsyncProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PuzzleAsyncProvider &&
        other.difficulty == difficulty &&
        other.category == category &&
        other.gameMode == gameMode;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, difficulty.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);
    hash = _SystemHash.combine(hash, gameMode.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PuzzleAsyncRef on AutoDisposeFutureProviderRef<Puzzle> {
  /// The parameter `difficulty` of this provider.
  Difficulty get difficulty;

  /// The parameter `category` of this provider.
  WordCategory get category;

  /// The parameter `gameMode` of this provider.
  GameMode get gameMode;
}

class _PuzzleAsyncProviderElement
    extends AutoDisposeFutureProviderElement<Puzzle>
    with PuzzleAsyncRef {
  _PuzzleAsyncProviderElement(super.provider);

  @override
  Difficulty get difficulty => (origin as PuzzleAsyncProvider).difficulty;
  @override
  WordCategory get category => (origin as PuzzleAsyncProvider).category;
  @override
  GameMode get gameMode => (origin as PuzzleAsyncProvider).gameMode;
}

String _$asyncGameStateNotifierHash() =>
    r'9edbaa8a332d35ff1ffe3501192670ff4358c586';

abstract class _$AsyncGameStateNotifier
    extends BuildlessAutoDisposeAsyncNotifier<GameState> {
  late final Difficulty difficulty;
  late final WordCategory category;
  late final GameMode gameMode;

  FutureOr<GameState> build({
    required Difficulty difficulty,
    required WordCategory category,
    required GameMode gameMode,
  });
}

/// Async game state notifier - handles loading state properly
///
/// Copied from [AsyncGameStateNotifier].
@ProviderFor(AsyncGameStateNotifier)
const asyncGameStateNotifierProvider = AsyncGameStateNotifierFamily();

/// Async game state notifier - handles loading state properly
///
/// Copied from [AsyncGameStateNotifier].
class AsyncGameStateNotifierFamily extends Family<AsyncValue<GameState>> {
  /// Async game state notifier - handles loading state properly
  ///
  /// Copied from [AsyncGameStateNotifier].
  const AsyncGameStateNotifierFamily();

  /// Async game state notifier - handles loading state properly
  ///
  /// Copied from [AsyncGameStateNotifier].
  AsyncGameStateNotifierProvider call({
    required Difficulty difficulty,
    required WordCategory category,
    required GameMode gameMode,
  }) {
    return AsyncGameStateNotifierProvider(
      difficulty: difficulty,
      category: category,
      gameMode: gameMode,
    );
  }

  @override
  AsyncGameStateNotifierProvider getProviderOverride(
    covariant AsyncGameStateNotifierProvider provider,
  ) {
    return call(
      difficulty: provider.difficulty,
      category: provider.category,
      gameMode: provider.gameMode,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'asyncGameStateNotifierProvider';
}

/// Async game state notifier - handles loading state properly
///
/// Copied from [AsyncGameStateNotifier].
class AsyncGameStateNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          AsyncGameStateNotifier,
          GameState
        > {
  /// Async game state notifier - handles loading state properly
  ///
  /// Copied from [AsyncGameStateNotifier].
  AsyncGameStateNotifierProvider({
    required Difficulty difficulty,
    required WordCategory category,
    required GameMode gameMode,
  }) : this._internal(
         () => AsyncGameStateNotifier()
           ..difficulty = difficulty
           ..category = category
           ..gameMode = gameMode,
         from: asyncGameStateNotifierProvider,
         name: r'asyncGameStateNotifierProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$asyncGameStateNotifierHash,
         dependencies: AsyncGameStateNotifierFamily._dependencies,
         allTransitiveDependencies:
             AsyncGameStateNotifierFamily._allTransitiveDependencies,
         difficulty: difficulty,
         category: category,
         gameMode: gameMode,
       );

  AsyncGameStateNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.difficulty,
    required this.category,
    required this.gameMode,
  }) : super.internal();

  final Difficulty difficulty;
  final WordCategory category;
  final GameMode gameMode;

  @override
  FutureOr<GameState> runNotifierBuild(
    covariant AsyncGameStateNotifier notifier,
  ) {
    return notifier.build(
      difficulty: difficulty,
      category: category,
      gameMode: gameMode,
    );
  }

  @override
  Override overrideWith(AsyncGameStateNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: AsyncGameStateNotifierProvider._internal(
        () => create()
          ..difficulty = difficulty
          ..category = category
          ..gameMode = gameMode,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        difficulty: difficulty,
        category: category,
        gameMode: gameMode,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<AsyncGameStateNotifier, GameState>
  createElement() {
    return _AsyncGameStateNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AsyncGameStateNotifierProvider &&
        other.difficulty == difficulty &&
        other.category == category &&
        other.gameMode == gameMode;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, difficulty.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);
    hash = _SystemHash.combine(hash, gameMode.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AsyncGameStateNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<GameState> {
  /// The parameter `difficulty` of this provider.
  Difficulty get difficulty;

  /// The parameter `category` of this provider.
  WordCategory get category;

  /// The parameter `gameMode` of this provider.
  GameMode get gameMode;
}

class _AsyncGameStateNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          AsyncGameStateNotifier,
          GameState
        >
    with AsyncGameStateNotifierRef {
  _AsyncGameStateNotifierProviderElement(super.provider);

  @override
  Difficulty get difficulty =>
      (origin as AsyncGameStateNotifierProvider).difficulty;
  @override
  WordCategory get category =>
      (origin as AsyncGameStateNotifierProvider).category;
  @override
  GameMode get gameMode => (origin as AsyncGameStateNotifierProvider).gameMode;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
