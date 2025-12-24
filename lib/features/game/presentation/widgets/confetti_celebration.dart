import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

/// Simple confetti celebration widget
class ConfettiCelebration extends StatefulWidget {
  const ConfettiCelebration({
    super.key,
    required this.onComplete,
  });

  final VoidCallback onComplete;

  @override
  State<ConfettiCelebration> createState() => _ConfettiCelebrationState();
}

class _ConfettiCelebrationState extends State<ConfettiCelebration>
    with TickerProviderStateMixin {
  late List<_ConfettiParticle> _particles;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    // Create particles
    final random = math.Random();
    _particles = List.generate(50, (index) {
      return _ConfettiParticle(
        x: random.nextDouble(),
        y: -0.1,
        color: _getRandomColor(random),
        size: 4 + random.nextDouble() * 6,
        speed: 0.3 + random.nextDouble() * 0.5,
        rotation: random.nextDouble() * math.pi * 2,
        rotationSpeed: (random.nextDouble() - 0.5) * 0.1,
      );
    });
    
    _controller.forward().then((_) {
      widget.onComplete();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getRandomColor(math.Random random) {
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.accent1,
      AppColors.accent2,
      AppColors.accent3,
      AppColors.accent4,
      AppColors.success,
    ];
    return colors[random.nextInt(colors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _ConfettiPainter(
            particles: _particles,
            progress: _controller.value,
          ),
          child: Container(),
        );
      },
    );
  }
}

class _ConfettiParticle {
  _ConfettiParticle({
    required this.x,
    required this.y,
    required this.color,
    required this.size,
    required this.speed,
    required this.rotation,
    required this.rotationSpeed,
  });

  double x;
  double y;
  final Color color;
  final double size;
  final double speed;
  double rotation;
  final double rotationSpeed;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({
    required this.particles,
    required this.progress,
  });

  final List<_ConfettiParticle> particles;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()..color = particle.color;
      
      final x = particle.x * size.width;
      final y = particle.y * size.height + (progress * size.height * particle.speed);
      final currentRotation = particle.rotation + (progress * particle.rotationSpeed * 10);
      
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(currentRotation);
      
      // Draw square confetti
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: particle.size,
          height: particle.size,
        ),
        paint,
      );
      
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

