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
  bool _audioInitialized = false;

  /// Initialize audio (required for web - needs user interaction)
  Future<void> initializeAudio() async {
    if (_audioInitialized) return;
    try {
      // On web, we need to play a silent sound first to unlock audio
      if (kIsWeb) {
        await _buttonPlayer.setReleaseMode(ReleaseMode.stop);
        // Try to play a very short silent sound to unlock audio context
        await _buttonPlayer.play(AssetSource('sounds/Heavy-popping.wav'));
        await Future.delayed(const Duration(milliseconds: 10));
        await _buttonPlayer.stop();
      }
      _audioInitialized = true;
    } catch (e) {
      if (kDebugMode) {
        print('Audio initialization error: $e');
      }
    }
  }

  /// Preload button click sound for instant playback
  Future<void> preloadButtonClick() async {
    if (_buttonSoundPreloaded) return;
    try {
      await _buttonPlayer.setSource(AssetSource('sounds/Heavy-popping.wav'));
      _buttonSoundPreloaded = true;
    } catch (e) {
      // Silently fail if audio can't be preloaded
    }
  }

  /// Play button click sound (Heavy-popping.wav)
  Future<void> playButtonClick() async {
    try {
      // Initialize audio on first play (for web)
      if (!_audioInitialized) {
        await initializeAudio();
      }
      if (_buttonSoundPreloaded) {
        // If preloaded, stop any current playback and play from start
        await _buttonPlayer.stop();
        await _buttonPlayer.play(AssetSource('sounds/Heavy-popping.wav'));
      } else {
        // If not preloaded, play from source (will be slower first time)
        await _buttonPlayer.play(AssetSource('sounds/Heavy-popping.wav'));
      }
    } catch (e) {
      if (kDebugMode) {
        print('Audio playback error: $e');
      }
    }
  }

  /// Play word found sound (alternates between two sounds)
  Future<void> playWordFound() async {
    try {
      // Initialize audio on first play (for web)
      if (!_audioInitialized) {
        await initializeAudio();
      }
      final soundIndex = _random.nextInt(2);
      final soundFile = soundIndex == 0
          ? 'sounds/dry-pop-up-notification-alert-2356.wav'
          : 'sounds/bubble-pop-up-alert-notification.wav';
      await _wordFoundPlayer.play(AssetSource(soundFile));
    } catch (e) {
      if (kDebugMode) {
        print('Audio playback error: $e');
      }
    }
  }

  /// Play puzzle completion sound (harp motif)
  Future<void> playPuzzleComplete() async {
    try {
      // Initialize audio on first play (for web)
      if (!_audioInitialized) {
        await initializeAudio();
      }
      await _completionPlayer.play(AssetSource('sounds/davince21__harp-motif1.mp3'));
    } catch (e) {
      if (kDebugMode) {
        print('Audio playback error: $e');
      }
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

