import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../logic/streak_calculator.dart';
import '../utils/constants.dart';

class WeekStrip extends StatelessWidget {
  final List<DateTime> completedDates;
  final Color activeColor;

  const WeekStrip({
    super.key,
    required this.completedDates,
    this.activeColor = AppColors.secondary,
  });

  List<DateTime> _getPast7Days() {
    final today = DateTime.now();
    return List.generate(7, (index) {
      return DateTime(today.year, today.month, today.day)
          .subtract(Duration(days: 6 - index));
    });
  }

  @override
  Widget build(BuildContext context) {
    final days = _getPast7Days();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days.map((date) {
        final isCompleted = StreakCalculator.isCompletedOnDate(completedDates, date);
        final isToday = DateTime.now().year == date.year &&
            DateTime.now().month == date.month &&
            DateTime.now().day == date.day;

        final dayLabel = DateFormat('E').format(date).substring(0, 1); // e.g., 'M', 'T'

        return Column(
          children: [
            Text(
              dayLabel,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isToday ? FontWeight.w800 : FontWeight.w500,
                color: isToday
                    ? (isDark ? AppColors.textLight : AppColors.textDark)
                    : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: AppDurations.quick,
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: isCompleted
                    ? activeColor
                    : isToday
                        ? activeColor.withOpacity(0.15)
                        : (isDark ? Colors.white10 : Colors.black.withOpacity(0.04)),
                shape: BoxShape.circle,
                border: isToday && !isCompleted
                    ? Border.all(color: activeColor, width: 1.5)
                    : null,
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 16,
                      )
                    : Text(
                        '${date.day}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                          color: isToday
                              ? activeColor
                              : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                        ),
                      ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
