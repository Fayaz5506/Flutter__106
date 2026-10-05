import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// StreakBadge Widget
///
/// Animation & Visual Logic:
/// - Displays flame icon + streak count.
/// - Badge background and flame icon color warm up progressively as streak grows:
///   * 0 - 2 days: Warm Amber/Orange
///   * 3 - 6 days: Vibrant Bright Orange
///   * 7 - 29 days: Crimson Flame Red
///   * 30+ days: Deep Inferno Gold/Red with glow
/// - Includes a subtle pulsing flame animation when active.
class StreakBadge extends StatefulWidget {
  final int streak;
  final bool isCompact;

  const StreakBadge({
    super.key,
    required this.streak,
    this.isCompact = false,
  });

  @override
  State<StreakBadge> createState() => _StreakBadgeState();
}

class _StreakBadgeState extends State<StreakBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: AppDurations.flamePulse,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.streak > 0) {
      _pulseController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant StreakBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.streak != oldWidget.streak) {
      if (widget.streak > 0) {
        _pulseController.forward(from: 0.0);
      } else {
        _pulseController.reset();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Color _getBadgeColor() {
    if (widget.streak >= 30) return AppColors.flameInferno;
    if (widget.streak >= 7) return AppColors.flameHot;
    if (widget.streak >= 3) return AppColors.primary;
    return AppColors.flameWarm;
  }

  Color _getBadgeBgColor() {
    return _getBadgeColor().withOpacity(0.12);
  }

  @override
  Widget build(BuildContext context) {
    final color = _getBadgeColor();
    final bgColor = _getBadgeBgColor();

    final padding = widget.isCompact
        ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
        : const EdgeInsets.symmetric(horizontal: 12, vertical: 6);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSpacings.radiusLg),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: widget.streak > 0
                ? _scaleAnimation
                : const AlwaysStoppedAnimation(1.0),
            child: Icon(
              Icons.local_fire_department_rounded,
              color: widget.streak > 0 ? color : Colors.grey,
              size: widget.isCompact ? 16 : 20,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '${widget.streak} ${widget.streak == 1 ? "day" : "days"}',
            style: TextStyle(
              color: widget.streak > 0 ? color : Colors.grey,
              fontSize: widget.isCompact ? 12 : 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
