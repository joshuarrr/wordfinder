import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Wrapper widget that enables swipe-to-go-back gesture on screens
/// Wrap your Scaffold with this widget to enable iOS-style swipe back gesture
/// with a wider gesture area (80px from left edge)
class SwipeableScreen extends StatefulWidget {
  const SwipeableScreen({
    super.key,
    required this.child,
    this.onPop,
    this.gestureWidth = 80.0,
  });

  final Widget child;
  final VoidCallback? onPop;
  final double gestureWidth;

  @override
  State<SwipeableScreen> createState() => _SwipeableScreenState();
}

class _SwipeableScreenState extends State<SwipeableScreen> {
  double _dragStartX = 0;
  double _totalDrag = 0;
  bool _isDragging = false;

  void _handlePop() {
    if (widget.onPop != null) {
      widget.onPop!();
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          _handlePop();
        }
      },
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (event) {
          // Start tracking if pointer is in the gesture area
          if (event.position.dx < widget.gestureWidth) {
            setState(() {
              _isDragging = true;
              _dragStartX = event.position.dx;
              _totalDrag = 0;
            });
          }
        },
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragStart: (details) {
            // Only start drag if starting from left gesture area
            if (details.globalPosition.dx < widget.gestureWidth) {
              setState(() {
                _isDragging = true;
                _dragStartX = details.globalPosition.dx;
                _totalDrag = 0;
              });
            }
          },
          onHorizontalDragUpdate: (details) {
            if (_isDragging) {
              final delta = details.globalPosition.dx - _dragStartX;
              // Only allow rightward drag (positive delta)
              if (delta > 0) {
                setState(() {
                  _totalDrag = delta.clamp(0.0, 400.0);
                });
              }
            }
          },
          onHorizontalDragEnd: (details) {
            if (_isDragging) {
              // If dragged more than 80px or with sufficient velocity, trigger pop
              final velocity = details.velocity.pixelsPerSecond.dx;
              if (_totalDrag > 80 || velocity > 400) {
                _handlePop();
              }
              setState(() {
                _isDragging = false;
                _totalDrag = 0;
              });
            }
          },
          onHorizontalDragCancel: () {
            setState(() {
              _isDragging = false;
              _totalDrag = 0;
            });
          },
          child: widget.child,
        ),
      ),
    );
  }
}

