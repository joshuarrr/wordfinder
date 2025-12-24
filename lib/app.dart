import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'core/router/router.dart';
import 'core/theme/theme.dart';

void _log(String message) {
  developer.log(message, name: 'perf');
  // ignore: avoid_print
  print(message);
}

/// Root application widget
class WordFinderApp extends StatelessWidget {
  const WordFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    _log('WordFinderApp.build()');
    return MaterialApp.router(
      title: 'Word Finder',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}
