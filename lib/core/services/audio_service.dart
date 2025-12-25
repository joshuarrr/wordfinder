import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

/// Audio service for playing sound effects
class AudioService {
  final AudioPlayer _wordFoundPlayer = AudioPlayer();
  final AudioPlayer _completionPlayer = AudioPlayer();
  final math.Random _random = math.Random();

  /// Get asset path - on web, Flutter uses 'assets/' prefix
  String _assetPath(String path) {
    return kIsWeb ? 'assets/$path' : path;
  }

  /// Play button click sound (Heavy-popping.wav)
  /// Use wordFoundPlayer since it works - create new instance if needed
  Future<void> playButtonClick() async {
    try {
      // Use a separate player instance for button clicks to avoid conflicts
      final buttonPlayer = AudioPlayer();
      await buttonPlayer.play(AssetSource(_assetPath('sounds/Heavy-popping.wav')));
      // Don't dispose immediately - let it play, then dispose after a delay
      Future.delayed(const Duration(seconds: 1), () => buttonPlayer.dispose());
    } catch (e) {
      // Silently fail if audio can't be played
    }
  }

  /// Play word found sound (alternates between two sounds)
  Future<void> playWordFound() async {
    try {
      final soundIndex = _random.nextInt(2);
      final soundFile = soundIndex == 0
          ? 'sounds/dry-pop-up-notification-alert-2356.wav'
          : 'sounds/bubble-pop-up-alert-notification.wav';
      await _wordFoundPlayer.play(AssetSource(_assetPath(soundFile)));
    } catch (e) {
      // Silently fail if audio can't be played
    }
  }

  /// Play puzzle completion sound (harp motif)
  Future<void> playPuzzleComplete() async {
    try {
      await _completionPlayer.play(AssetSource(_assetPath('sounds/davince21__harp-motif1.mp3')));
    } catch (e) {
      // Silently fail if audio can't be played
    }
  }

  void dispose() {
    _wordFoundPlayer.dispose();
    _completionPlayer.dispose();
  }
}

/// Provider for audio service
final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  ref.onDispose(() => service.dispose());
  return service;
});
