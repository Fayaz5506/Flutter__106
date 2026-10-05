import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';

/// AnimatedCheck Custom Widget
///
/// Animation Logic:
/// 1. Tapping the checkbox starts an [AnimationController] running for ~450ms.
/// 2. As progress proceeds from 0.0 to 1.0, the [CustomPainter] draws:
///    a) A circular fill expanding from center.
///    b) The checkmark path drawn progressively via [PathMetric] path truncation.
/// 3. A subtle scale "pop" is applied using a curve.
/// 4. When [AnimationStatus.completed] fires, [onAnimationDone] is triggered to officially set state to done.
class AnimatedCheck extends StatefulWidget {
  final bool checked;
  final VoidCallback onAnimationDone;
  final VoidCallback? onUnchecked;
  final Color activeColor;
  final double size;

  const AnimatedCheck({
    super.key,
    required this.checked,
    required this.onAnimationDone,
    this.onUnchecked,
    this.activeColor = AppColors.secondary,
    this.size = 28.0,
  });

  @override
  State<AnimatedCheck> createState() => _AnimatedCheckState();
}

class _AnimatedCheckState extends State<AnimatedCheck>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _checkAnimation;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.checkAnimation,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.2).chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0).chain(CurveTween(curve: Curves.easeIn)),
        weight: 60,
      ),
    ]).animate(_controller);

    _checkAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && _isAnimating) {
        _isAnimating = false;
        widget.onAnimationDone();
      }
    });

    if (widget.checked) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedCheck oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.checked != oldWidget.checked && !_isAnimating) {
      if (widget.checked) {
        _controller.value = 1.0;
      } else {
        _controller.value = 0.0;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_isAnimating) return;

    HapticFeedback.lightImpact();

    if (widget.checked) {
      // Toggle off instantly
      _controller.reset();
      widget.onUnchecked?.call();
    } else {
      // Play checkmark draw animation first!
      _isAnimating = true;
      _controller.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              size: Size(widget.size, widget.size),
              painter: _CheckPainter(
                progress: _checkAnimation.value,
                checked: widget.checked,
                activeColor: widget.activeColor,
                theme: Theme.of(context),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CheckPainter extends CustomPainter {
  final double progress;
  final bool checked;
  final Color activeColor;
  final ThemeData theme;

  _CheckPainter({
    required this.progress,
    required this.checked,
    required this.activeColor,
    required this.theme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 1.5;

    // Unchecked circular border
    final borderPaint = Paint()
      ..color = (checked || progress > 0)
          ? activeColor
          : (theme.brightness == Brightness.dark
              ? Colors.white38
              : Colors.black26)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(center, radius, borderPaint);

    // Background fill expanding
    if (progress > 0 || checked) {
      final fillProgress = checked && progress == 0 ? 1.0 : math.min(1.0, progress * 1.5);
      final fillPaint = Paint()
        ..color = activeColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, radius * fillProgress, fillPaint);
    }

    // Checkmark stroke drawing
    final drawProgress = checked && progress == 0 ? 1.0 : progress;
    if (drawProgress > 0) {
      final checkPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final path = Path();
      // Define checkmark path coordinates based on widget size
      final p1 = Offset(size.width * 0.28, size.height * 0.52);
      final p2 = Offset(size.width * 0.44, size.height * 0.68);
      final p3 = Offset(size.width * 0.72, size.height * 0.36);

      path.moveTo(p1.dx, p1.dy);

      // First leg of check (down to corner)
      if (drawProgress <= 0.4) {
        final subProgress = drawProgress / 0.4;
        final currentX = p1.dx + (p2.dx - p1.dx) * subProgress;
        final currentY = p1.dy + (p2.dy - p1.dy) * subProgress;
        path.lineTo(currentX, currentY);
      } else {
        path.lineTo(p2.dx, p2.dy);
        // Second leg of check (up to tip)
        final subProgress = (drawProgress - 0.4) / 0.6;
        final currentX = p2.dx + (p3.dx - p2.dx) * subProgress;
        final currentY = p2.dy + (p3.dy - p2.dy) * subProgress;
        path.lineTo(currentX, currentY);
      }

      canvas.drawPath(path, checkPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CheckPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.checked != checked ||
        oldDelegate.activeColor != activeColor;
  }
}
