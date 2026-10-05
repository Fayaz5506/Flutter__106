import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/app_provider.dart';
import '../utils/constants.dart';
import '../utils/date_formatter.dart';
import '../logic/streak_calculator.dart';
import 'animated_check.dart';
import 'streak_badge.dart';
import 'week_strip.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback onEdit;
  final VoidCallback? onCompletedBurst;

  const HabitCard({
    super.key,
    required this.habit,
    required this.onEdit,
    this.onCompletedBurst,
  });

  IconData _getIconData(String name) {
    switch (name) {
      case 'self_improvement':
        return Icons.self_improvement_rounded;
      case 'menu_book':
        return Icons.menu_book_rounded;
      case 'water_drop':
        return Icons.water_drop_rounded;
      case 'fitness_center':
        return Icons.fitness_center_rounded;
      case 'directions_run':
        return Icons.directions_run_rounded;
      case 'bedtime':
        return Icons.bedtime_rounded;
      case 'code':
        return Icons.code_rounded;
      case 'brush':
        return Icons.brush_rounded;
      case 'local_cafe':
        return Icons.local_cafe_rounded;
      case 'favorite':
        return Icons.favorite_rounded;
      case 'star':
      default:
        return Icons.star_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final today = DateFormatter.dateOnly(DateTime.now());
    final isDoneToday = StreakCalculator.isCompletedOnDate(habit.completedDates, today);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacings.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppSpacings.radiusMd),
        border: Border.all(
          color: isDoneToday
              ? habit.color.withOpacity(0.4)
              : (isDark ? Colors.white10 : Colors.black.withOpacity(0.06)),
          width: isDoneToday ? 1.5 : 1.0,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(AppSpacings.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacings.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Habit Icon + Name + Streak Badge + Checkbox
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon Container with habit background color
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: habit.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(AppSpacings.radiusSm + 4),
                    ),
                    child: Icon(
                      _getIconData(habit.iconName),
                      color: habit.color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppSpacings.md),
                  // Habit Name & Streak Badge
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        StreakBadge(
                          streak: habit.currentStreak,
                          isCompact: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacings.sm),
                  // Animated Completion Checkbox
                  AnimatedCheck(
                    checked: isDoneToday,
                    activeColor: habit.color,
                    size: 32,
                    onAnimationDone: () async {
                      HapticFeedback.mediumImpact();
                      final newlyCompleted = await provider.toggleHabitDoneToday(habit.id);
                      if (newlyCompleted) {
                        onCompletedBurst?.call();
                      }
                    },
                    onUnchecked: () {
                      provider.toggleHabitDoneToday(habit.id);
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSpacings.md),
              const Divider(height: 1, thickness: 0.5),
              const SizedBox(height: AppSpacings.sm + 4),
              // Bottom 7-Day Mini Week Strip
              WeekStrip(
                completedDates: habit.completedDates,
                activeColor: habit.color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
