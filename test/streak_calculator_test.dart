import 'package:flutter_test/flutter_test.dart';
import 'package:dailywin/logic/streak_calculator.dart';

void main() {
  group('StreakCalculator Unit Tests', () {
    final today = DateTime(2026, 10, 4);
    final yesterday = DateTime(2026, 10, 3);
    final day2Ago = DateTime(2026, 10, 2);
    final day3Ago = DateTime(2026, 10, 1);
    final day5Ago = DateTime(2026, 9, 29);

    test('Empty list returns 0 for current and best streak', () {
      expect(StreakCalculator.calculateCurrentStreak([], relativeTo: today), equals(0));
      expect(StreakCalculator.calculateBestStreak([]), equals(0));
    });

    test('Consecutive days up to today calculates correct current streak', () {
      final dates = [day3Ago, day2Ago, yesterday, today];
      expect(StreakCalculator.calculateCurrentStreak(dates, relativeTo: today), equals(4));
      expect(StreakCalculator.calculateBestStreak(dates), equals(4));
    });

    test('Streak stays alive when today is not completed yet but yesterday was', () {
      final dates = [day3Ago, day2Ago, yesterday];
      expect(StreakCalculator.calculateCurrentStreak(dates, relativeTo: today), equals(3));
      expect(StreakCalculator.calculateBestStreak(dates), equals(3));
    });

    test('Gap in completion resets current streak', () {
      // Completed day3Ago and today, but missed day2Ago and yesterday
      final dates = [day3Ago, today];
      expect(StreakCalculator.calculateCurrentStreak(dates, relativeTo: today), equals(1));
      expect(StreakCalculator.calculateBestStreak(dates), equals(1));
    });

    test('Best streak retains historical maximum run even when current streak drops', () {
      // 3 consecutive days in past (day5Ago, day4Ago, day3Ago), then gap, then today
      final day4Ago = DateTime(2026, 9, 30);
      final dates = [day5Ago, day4Ago, day3Ago, today];
      expect(StreakCalculator.calculateCurrentStreak(dates, relativeTo: today), equals(1));
      expect(StreakCalculator.calculateBestStreak(dates), equals(3));
    });

    test('Handles duplicate dates on same day gracefully without double counting', () {
      final dates = [today, today, yesterday, yesterday, day2Ago];
      expect(StreakCalculator.calculateCurrentStreak(dates, relativeTo: today), equals(3));
      expect(StreakCalculator.calculateBestStreak(dates), equals(3));
    });

    test('isCompletedOnDate returns true only for matching dates', () {
      final dates = [yesterday, today];
      expect(StreakCalculator.isCompletedOnDate(dates, today), isTrue);
      expect(StreakCalculator.isCompletedOnDate(dates, yesterday), isTrue);
      expect(StreakCalculator.isCompletedOnDate(dates, day3Ago), isFalse);
    });
  });
}
