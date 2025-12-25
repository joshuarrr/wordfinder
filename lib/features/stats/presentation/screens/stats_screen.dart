import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/widgets.dart';
import '../widgets/stats_content.dart';

/// Stats screen showing advanced statistics
class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: AppIconButton(
          icon: Icons.arrow_back_rounded,
          onPressed: () => context.pop(),
          backgroundColor: Colors.transparent,
        ),
        title: const Text('Statistics'),
      ),
      body: const SafeArea(
        child: StatsContent(),
      ),
    );
  }
}

