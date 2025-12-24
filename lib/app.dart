import 'package:flutter/material.dart';

import 'core/router/router.dart';
import 'core/theme/theme.dart';

/// Root application widget
class WordFinderApp extends StatelessWidget {
  const WordFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Word Finder',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}

