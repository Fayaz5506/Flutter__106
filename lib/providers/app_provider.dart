import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';
import '../models/habit.dart';
import '../models/priority.dart';
import '../services/storage_service.dart';
import '../logic/streak_calculator.dart';
import '../utils/date_formatter.dart';

enum TaskFilter { all, pending, done }

class AppProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  final _uuid = const Uuid();

  List<Task> _tasks = [];
  List<Habit> _habits = [];
  TaskFilter _currentFilter = TaskFilter.all;
  bool _isDarkMode = false;
  bool _isLoading = true;

  // Getters
  List<Task> get tasks => _tasks;
  List<Habit> get habits => _habits;
  TaskFilter get currentFilter => _currentFilter;
  bool get isDarkMode => _isDarkMode;
  bool get isLoading => _isLoading;

  // Filtered tasks getter
  List<Task> get filteredTasks {
    switch (_currentFilter) {
      case TaskFilter.pending:
        return _tasks.where((t) => !t.isDone).toList();
      case TaskFilter.done:
        return _tasks.where((t) => t.isDone).toList();
      case TaskFilter.all:
        return _tasks;
    }
  }

  // Task Stats
  int get totalTasksCount => _tasks.length;
  int get completedTasksCount => _tasks.where((t) => t.isDone).length;
  double get taskCompletionRatio =>
      _tasks.isEmpty ? 0.0 : completedTasksCount / totalTasksCount;

  // Habit Stats
  Habit? get longestStreakHabit {
    if (_habits.isEmpty) return null;
    Habit? top;
    for (final h in _habits) {
      if (top == null || h.currentStreak > top.currentStreak) {
        top = h;
      }
    }
    return top;
  }

  int get totalHabitCompletions =>
      _habits.fold(0, (sum, h) => sum + h.completedDates.length);
  
  int get activeHabitsCount => _habits.length;

  int get bestStreakEver => _habits.fold(
      0, (max, h) => h.bestStreak > max ? h.bestStreak : max);

  AppProvider() {
    init();
  }

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    await _storageService.initializeSeedDataIfNeeded();
    _isDarkMode = await _storageService.loadThemeMode();
    _tasks = await _storageService.loadTasks();
    _habits = await _storageService.loadHabits();

    // Recalculate habit streaks on load to stay up to date after restarts/midnight
    _recalculateAllStreaks();

    _isLoading = false;
    notifyListeners();
  }

  // Task Actions
  void setTaskFilter(TaskFilter filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  Future<void> addTask({
    required String title,
    required DateTime dueTime,
    required Priority priority,
  }) async {
    final newTask = Task(
      id: _uuid.v4(),
      title: title,
      dueTime: dueTime,
      priority: priority,
      isDone: false,
    );
    _tasks.insert(0, newTask);
    notifyListeners();
    await _storageService.saveTasks(_tasks);
  }

  Future<void> editTask({
    required String id,
    required String title,
    required DateTime dueTime,
    required Priority priority,
  }) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(
        title: title,
        dueTime: dueTime,
        priority: priority,
      );
      notifyListeners();
      await _storageService.saveTasks(_tasks);
    }
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
    await _storageService.saveTasks(_tasks);
  }

  /// Restores a deleted task at its index (undo functionality)
  Future<void> restoreTask(Task task, int originalIndex) async {
    final insertPos = originalIndex.clamp(0, _tasks.length);
    _tasks.insert(insertPos, task);
    notifyListeners();
    await _storageService.saveTasks(_tasks);
  }

  /// Called strictly AFTER checkmark animation completes (or when toggling back)
  Future<void> setTaskCompletion(String id, bool isDone) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(isDone: isDone);
      notifyListeners();
      await _storageService.saveTasks(_tasks);
    }
  }

  // Habit Actions
  Future<void> addHabit({
    required String name,
    required String iconName,
    required String colorHex,
  }) async {
    final newHabit = Habit(
      id: _uuid.v4(),
      name: name,
      iconName: iconName,
      colorHex: colorHex,
      completedDates: [],
      currentStreak: 0,
      bestStreak: 0,
    );
    _habits.insert(0, newHabit);
    notifyListeners();
    await _storageService.saveHabits(_habits);
  }

  Future<void> editHabit({
    required String id,
    required String name,
    required String iconName,
    required String colorHex,
  }) async {
    final index = _habits.indexWhere((h) => h.id == id);
    if (index != -1) {
      _habits[index] = _habits[index].copyWith(
        name: name,
        iconName: iconName,
        colorHex: colorHex,
      );
      notifyListeners();
      await _storageService.saveHabits(_habits);
    }
  }

  Future<void> deleteHabit(String id) async {
    _habits.removeWhere((h) => h.id == id);
    notifyListeners();
    await _storageService.saveHabits(_habits);
  }

  /// Toggle habit completion for today
  Future<bool> toggleHabitDoneToday(String habitId) async {
    final index = _habits.indexWhere((h) => h.id == habitId);
    if (index == -1) return false;

    final habit = _habits[index];
    final today = DateFormatter.dateOnly(DateTime.now());
    final isDone = StreakCalculator.isCompletedOnDate(habit.completedDates, today);

    List<DateTime> updatedDates = List.from(habit.completedDates);

    bool newlyCompleted = false;
    if (isDone) {
      // Remove today from completed dates
      updatedDates.removeWhere((d) => DateFormatter.isSameDay(d, today));
    } else {
      // Add today to completed dates (ensuring date-only & avoiding duplicates)
      if (!updatedDates.any((d) => DateFormatter.isSameDay(d, today))) {
        updatedDates.add(today);
        newlyCompleted = true;
      }
    }

    // Recalculate streak using loop algorithms
    final currentStreak = StreakCalculator.calculateCurrentStreak(updatedDates);
    final bestStreak = StreakCalculator.calculateBestStreak(updatedDates);

    _habits[index] = habit.copyWith(
      completedDates: updatedDates,
      currentStreak: currentStreak,
      bestStreak: bestStreak,
    );

    notifyListeners();
    await _storageService.saveHabits(_habits);
    return newlyCompleted;
  }

  void _recalculateAllStreaks() {
    for (int i = 0; i < _habits.length; i++) {
      final h = _habits[i];
      final currentStreak = StreakCalculator.calculateCurrentStreak(h.completedDates);
      final bestStreak = StreakCalculator.calculateBestStreak(h.completedDates);
      _habits[i] = h.copyWith(
        currentStreak: currentStreak,
        bestStreak: bestStreak,
      );
    }
  }

  // Settings Actions
  Future<void> toggleThemeMode() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    await _storageService.saveThemeMode(_isDarkMode);
  }

  Future<void> resetToSeedData() async {
    _isLoading = true;
    notifyListeners();
    await _storageService.seedDefaultData();
    _tasks = await _storageService.loadTasks();
    _habits = await _storageService.loadHabits();
    _recalculateAllStreaks();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> clearAllData() async {
    _isLoading = true;
    notifyListeners();
    await _storageService.clearAll();
    _tasks = [];
    _habits = [];
    _isLoading = false;
    notifyListeners();
  }
}
