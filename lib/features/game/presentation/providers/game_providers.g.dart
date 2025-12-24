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
String _$gameStateNotifierHash() => r'21a008835628bbab54c483d092820218e1e2e063';

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

abstract class _$GameStateNotifier
    extends BuildlessAutoDisposeNotifier<GameState> {
  late final Difficulty difficulty;
  late final WordCategory category;
  late final GameMode gameMode;

  GameState build({
    required Difficulty difficulty,
    required WordCategory category,
    required GameMode gameMode,
  });
}

/// Game state notifier
///
/// Copied from [GameStateNotifier].
@ProviderFor(GameStateNotifier)
const gameStateNotifierProvider = GameStateNotifierFamily();

/// Game state notifier
///
/// Copied from [GameStateNotifier].
class GameStateNotifierFamily extends Family<GameState> {
  /// Game state notifier
  ///
  /// Copied from [GameStateNotifier].
  const GameStateNotifierFamily();

  /// Game state notifier
  ///
  /// Copied from [GameStateNotifier].
  GameStateNotifierProvider call({
    required Difficulty difficulty,
    required WordCategory category,
    required GameMode gameMode,
  }) {
    return GameStateNotifierProvider(
      difficulty: difficulty,
      category: category,
      gameMode: gameMode,
    );
  }

  @override
  GameStateNotifierProvider getProviderOverride(
    covariant GameStateNotifierProvider provider,
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
  String? get name => r'gameStateNotifierProvider';
}

/// Game state notifier
///
/// Copied from [GameStateNotifier].
class GameStateNotifierProvider
    extends AutoDisposeNotifierProviderImpl<GameStateNotifier, GameState> {
  /// Game state notifier
  ///
  /// Copied from [GameStateNotifier].
  GameStateNotifierProvider({
    required Difficulty difficulty,
    required WordCategory category,
    required GameMode gameMode,
  }) : this._internal(
         () => GameStateNotifier()
           ..difficulty = difficulty
           ..category = category
           ..gameMode = gameMode,
         from: gameStateNotifierProvider,
         name: r'gameStateNotifierProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$gameStateNotifierHash,
         dependencies: GameStateNotifierFamily._dependencies,
         allTransitiveDependencies:
             GameStateNotifierFamily._allTransitiveDependencies,
         difficulty: difficulty,
         category: category,
         gameMode: gameMode,
       );

  GameStateNotifierProvider._internal(
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
  GameState runNotifierBuild(covariant GameStateNotifier notifier) {
    return notifier.build(
      difficulty: difficulty,
      category: category,
      gameMode: gameMode,
    );
  }

  @override
  Override overrideWith(GameStateNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: GameStateNotifierProvider._internal(
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
  AutoDisposeNotifierProviderElement<GameStateNotifier, GameState>
  createElement() {
    return _GameStateNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GameStateNotifierProvider &&
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
mixin GameStateNotifierRef on AutoDisposeNotifierProviderRef<GameState> {
  /// The parameter `difficulty` of this provider.
  Difficulty get difficulty;

  /// The parameter `category` of this provider.
  WordCategory get category;

  /// The parameter `gameMode` of this provider.
  GameMode get gameMode;
}

class _GameStateNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<GameStateNotifier, GameState>
    with GameStateNotifierRef {
  _GameStateNotifierProviderElement(super.provider);

  @override
  Difficulty get difficulty => (origin as GameStateNotifierProvider).difficulty;
  @override
  WordCategory get category => (origin as GameStateNotifierProvider).category;
  @override
  GameMode get gameMode => (origin as GameStateNotifierProvider).gameMode;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
