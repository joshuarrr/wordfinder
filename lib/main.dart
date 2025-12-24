import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as developer;

import 'app.dart';

// Performance monitoring
final Stopwatch _appStopwatch = Stopwatch()..start();

void _log(String message) {
  final elapsed = _appStopwatch.elapsedMilliseconds;
  developer.log('[$elapsed ms] $message', name: 'perf');
  // ignore: avoid_print
  print('[$elapsed ms] $message');
}

void main() async {
  _log('main() started');
  
  WidgetsFlutterBinding.ensureInitialized();
  _log('WidgetsFlutterBinding initialized');

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  _log('Orientations set');

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  _log('SystemChrome configured');

  runApp(
    const ProviderScope(
      child: WordFinderApp(),
    ),
  );
  _log('runApp() called');
}
