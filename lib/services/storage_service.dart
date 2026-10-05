import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';
import '../models/habit.dart';
import '../models/priority.dart';
import '../logic/streak_calculator.dart';

class StorageService {
  static const String _tasksKey = 'dailywin_tasks_v1';
  static const String _habitsKey = 'dailywin_habits_v1';
  static const String _themeKey = 'dailywin_is_dark_v1';
  static const String _initializedKey = 'dailywin_initialized_v1';

  final _uuid = const Uuid();

  /// Saves list of tasks to SharedPreferences as JSON string
  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = tasks.map((t) => t.toJson()).toList();
    await prefs.setString(_tasksKey, jsonEncode(jsonList));
  }

  /// Loads list of tasks from SharedPreferences
  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_tasksKey);
    if (raw == null) return [];
    try {
      final List<dynamic> jsonList = jsonDecode(raw) as List<dynamic>;
      return jsonList.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  /// Saves list of habits to SharedPreferences as JSON string
  Future<void> saveHabits(List<Habit> habits) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = habits.map((h) => h.toJson()).toList();
    await prefs.setString(_habitsKey, jsonEncode(jsonList));
  }

  /// Loads list of habits from SharedPreferences
  Future<List<Habit>> loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_habitsKey);
    if (raw == null) return [];
    try {
      final List<dynamic> jsonList = jsonDecode(raw) as List<dynamic>;
      return jsonList.map((e) => Habit.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  /// Saves dark theme preference
  Future<void> saveThemeMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }

  /// Loads dark theme preference
  Future<bool> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false;
  }

  /// Checks if app is launched for the first time; if so, populates initial sample seed data
  Future<void> initializeSeedDataIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final isInitialized = prefs.getBool(_initializedKey) ?? false;
    if (!isInitialized) {
      await seedDefaultData();
      await prefs.setBool(_initializedKey, true);
    }
  }

  /// Populates rich sample seed data for first launch or reset
  Future<void> seedDefaultData() async {
    final now = DateTime.now();

    // Default tasks
    final tasks = [
      Task(
        id: _uuid.v4(),
        title: 'Design DailyWin app dashboard & icons',
        dueTime: DateTime(now.year, now.month, now.day, 18, 30),
        priority: Priority.high,
        isDone: false,
      ),
      Task(
        id: _uuid.v4(),
        title: 'Review pull request #42 & merge feature branch',
        dueTime: DateTime(now.year, now.month, now.day, 16, 0),
        priority: Priority.medium,
        isDone: true,
      ),
      Task(
        id: _uuid.v4(),
        title: 'Water balcony plants and refill bird feeder',
        dueTime: DateTime(now.year, now.month, now.day, 20, 0),
        priority: Priority.low,
        isDone: false,
      ),
      Task(
        id: _uuid.v4(),
        title: 'Schedule weekly team sync meeting',
        dueTime: DateTime(now.year, now.month, now.day, 14, 0),
        priority: Priority.medium,
        isDone: false,
      ),
    ];

    // Default habits with streak history
    final yesterday = now.subtract(const Duration(days: 1));
    final day2 = now.subtract(const Duration(days: 2));
    final day3 = now.subtract(const Duration(days: 3));
    final day4 = now.subtract(const Duration(days: 4));

    final meditationDates = [day4, day3, day2, yesterday, now];
    final readingDates = [day3, day2, yesterday];
    final waterDates = [now];

    final habit1 = Habit(
      id: _uuid.v4(),
      name: 'Morning Meditation (10 mins)',
      iconName: 'self_improvement',
      colorHex: 'FF7A00',
      completedDates: meditationDates,
      currentStreak: StreakCalculator.calculateCurrentStreak(meditationDates),
      bestStreak: StreakCalculator.calculateBestStreak(meditationDates),
    );

    final habit2 = Habit(
      id: _uuid.v4(),
      name: 'Read 20 Pages of a Book',
      iconName: 'menu_book',
      colorHex: '00A68C',
      completedDates: readingDates,
      currentStreak: StreakCalculator.calculateCurrentStreak(readingDates),
      bestStreak: StreakCalculator.calculateBestStreak(readingDates),
    );

    final habit3 = Habit(
      id: _uuid.v4(),
      name: 'Drink 2.5 Liters Water',
      iconName: 'water_drop',
      colorHex: '3B82F6',
      completedDates: waterDates,
      currentStreak: StreakCalculator.calculateCurrentStreak(waterDates),
      bestStreak: StreakCalculator.calculateBestStreak(waterDates),
    );

    await saveTasks(tasks);
    await saveHabits([habit1, habit2, habit3]);
  }

  /// Clears all local storage
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tasksKey);
    await prefs.remove(_habitsKey);
    await prefs.setBool(_initializedKey, true);
  }
}
