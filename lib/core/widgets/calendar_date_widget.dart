import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Calendar widget displaying a custom calendar icon with the current date
class CalendarDateWidget extends StatelessWidget {
  const CalendarDateWidget({
    super.key,
    this.size = 48,
    this.backgroundColor,
    this.iconColor,
    this.dateColor,
  });

  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? dateColor;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final day = now.day;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.accent1,
        borderRadius: AppSpacing.borderRadiusMd,
      ),
      child: CustomPaint(
        painter: _CalendarIconPainter(
          day: day,
          iconColor: iconColor ?? AppColors.textPrimary,
          dateColor: dateColor ?? AppColors.textPrimary,
        ),
        size: Size(size, size),
      ),
    );
  }
}

class _CalendarIconPainter extends CustomPainter {
  _CalendarIconPainter({
    required this.day,
    required this.iconColor,
    required this.dateColor,
  });

  final int day;
  final Color iconColor;
  final Color dateColor;

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = iconColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.025;

    final whiteFill = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final padding = size.width * 0.12;
    final calendarWidth = size.width - padding * 2;
    final calendarHeight = size.height - padding * 2;
    final headerHeight = calendarHeight * 0.25;

    // Draw calendar base with uniform border
    final calendarRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(padding, padding, calendarWidth, calendarHeight),
      Radius.circular(size.width * 0.06),
    );
    canvas.drawRRect(calendarRect, whiteFill);
    canvas.drawRRect(calendarRect, strokePaint);

    // Draw rings on top
    final ringPaint = Paint()
      ..color = iconColor
      ..style = PaintingStyle.fill;

    final ringRadius = size.width * 0.025;
    final ringY = padding + headerHeight * 0.4;
    canvas.drawCircle(
      Offset(padding + calendarWidth * 0.25, ringY),
      ringRadius,
      ringPaint,
    );
    canvas.drawCircle(
      Offset(padding + calendarWidth * 0.75, ringY),
      ringRadius,
      ringPaint,
    );

    // Draw red divider line
    final dividerY = padding + headerHeight;
    final dividerPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.025;

    canvas.drawLine(
      Offset(padding + size.width * 0.02, dividerY),
      Offset(size.width - padding - size.width * 0.02, dividerY),
      dividerPaint,
    );

    // Draw date number in the main area
    final textPainter = TextPainter(
      text: TextSpan(
        text: day.toString(),
        style: TextStyle(
          fontSize: size.width * 0.4,
          fontWeight: FontWeight.bold,
          color: dateColor,
          height: 1.0,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final dateAreaY =
        padding + headerHeight + (calendarHeight - headerHeight) / 2;
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        dateAreaY - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(_CalendarIconPainter oldDelegate) {
    return oldDelegate.day != day ||
        oldDelegate.iconColor != iconColor ||
        oldDelegate.dateColor != dateColor;
  }
}
