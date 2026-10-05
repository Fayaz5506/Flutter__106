/// Utility class containing loop-based streak calculations for habits.
class StreakCalculator {
  /// Calculates the current streak of consecutive completed days ending today or yesterday.
  ///
  /// Logic:
  /// 1. Convert all completed dates to a unique Set of date-only objects (year, month, day).
  /// 2. Get today's date-only reference (or optional relativeTo date).
  /// 3. If today is NOT in the set, check if yesterday is in the set.
  ///    - If today is not done AND yesterday is not done, streak is 0.
  ///    - If yesterday is done, start checking backwards from yesterday.
  /// 4. If today IS in the set, start checking backwards from today.
  /// 5. Loop backwards day by day while the date exists in the set, incrementing streak counter.
  static int calculateCurrentStreak(
    List<DateTime> completedDates, {
    DateTime? relativeTo,
  }) {
    if (completedDates.isEmpty) return 0;

    // Normalize all dates to date-only (year, month, day) to strip time components
    final Set<String> dateSet = completedDates
        .map((d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}')
        .toSet();

    final now = relativeTo ?? DateTime.now();
    DateTime cursor = DateTime(now.year, now.month, now.day);
    String cursorKey = '${cursor.year}-${cursor.month.toString().padLeft(2, '0')}-${cursor.day.toString().padLeft(2, '0')}';

    // If today is not completed yet, the streak is alive if yesterday was completed
    if (!dateSet.contains(cursorKey)) {
      cursor = cursor.subtract(const Duration(days: 1));
      cursorKey = '${cursor.year}-${cursor.month.toString().padLeft(2, '0')}-${cursor.day.toString().padLeft(2, '0')}';
    }

    int streak = 0;

    // Loop backwards day by day as long as the date is present in our completion set
    while (dateSet.contains(cursorKey)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
      cursorKey = '${cursor.year}-${cursor.month.toString().padLeft(2, '0')}-${cursor.day.toString().padLeft(2, '0')}';
    }

    return streak;
  }

  /// Calculates the best (longest) streak of consecutive completed days in history.
  ///
  /// Logic:
  /// 1. Normalize dates to date-only objects and remove duplicates.
  /// 2. Sort the dates in ascending order.
  /// 3. Loop through sorted dates: if current date is exactly 1 day after previous date,
  ///    increment current run count; otherwise reset run count to 1.
  /// 4. Track maximum run count observed.
  static int calculateBestStreak(List<DateTime> completedDates) {
    if (completedDates.isEmpty) return 0;

    // Normalize and extract unique date-only instances
    final uniqueDates = completedDates
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet()
        .toList()
      ..sort();

    int maxStreak = 0;
    int currentRun = 0;

    for (int i = 0; i < uniqueDates.length; i++) {
      if (i == 0) {
        currentRun = 1;
      } else {
        final diff = uniqueDates[i].difference(uniqueDates[i - 1]).inDays;
        if (diff == 1) {
          currentRun++;
        } else if (diff > 1) {
          currentRun = 1;
        }
      }

      if (currentRun > maxStreak) {
        maxStreak = currentRun;
      }
    }

    return maxStreak;
  }

  /// Helper to check if a habit was completed on a specific date.
  static bool isCompletedOnDate(List<DateTime> completedDates, DateTime targetDate) {
    final target = DateTime(targetDate.year, targetDate.month, targetDate.day);
    return completedDates.any((d) =>
        d.year == target.year && d.month == target.month && d.day == target.day);
  }
}
