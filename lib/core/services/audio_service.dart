import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

/// Audio service for playing sound effects
class AudioService {
  final AudioPlayer _buttonPlayer = AudioPlayer();
  final AudioPlayer _wordFoundPlayer = AudioPlayer();
  final AudioPlayer _completionPlayer = AudioPlayer();
  final math.Random _random = math.Random();

  bool _buttonSoundPreloaded = false;

  /// Get asset path - on web, Flutter uses 'assets/' prefix
  String _assetPath(String path) {
    return kIsWeb ? 'assets/$path' : path;
  }

  /// Preload button click sound for instant playback
  Future<void> preloadButtonClick() async {
    if (_buttonSoundPreloaded) return;
    try {
      await _buttonPlayer.setSource(AssetSource(_assetPath('sounds/Heavy-popping.wav')));
      _buttonSoundPreloaded = true;
    } catch (e) {
      // Silently fail if audio can't be preloaded
    }
  }

  /// Play button click sound (Heavy-popping.wav)
  Future<void> playButtonClick() async {
    try {
      if (_buttonSoundPreloaded) {
        // If preloaded, stop any current playback and play from start
        await _buttonPlayer.stop();
        await _buttonPlayer.play(AssetSource(_assetPath('sounds/Heavy-popping.wav')));
      } else {
        // If not preloaded, play from source (will be slower first time)
        await _buttonPlayer.play(AssetSource(_assetPath('sounds/Heavy-popping.wav')));
      }
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
    _buttonPlayer.dispose();
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
