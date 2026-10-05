import 'package:flutter/material.dart';

class Habit {
  final String id;
  final String name;
  final String iconName; // e.g. "fitness_center", "book", "water_drop", or emoji
  final String colorHex; // e.g. "FF7A00"
  final List<DateTime> completedDates; // Streak history (date-only)
  final int currentStreak;
  final int bestStreak;
  final DateTime createdAt;

  Habit({
    required this.id,
    required this.name,
    this.iconName = 'star',
    this.colorHex = 'FF7A00',
    List<DateTime>? completedDates,
    this.currentStreak = 0,
    this.bestStreak = 0,
    DateTime? createdAt,
  })  : completedDates = completedDates ?? [],
        createdAt = createdAt ?? DateTime.now();

  Habit copyWith({
    String? id,
    String? name,
    String? iconName,
    String? colorHex,
    List<DateTime>? completedDates,
    int? currentStreak,
    int? bestStreak,
    DateTime? createdAt,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
      completedDates: completedDates ?? List.from(this.completedDates),
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Color get color {
    try {
      final buffer = StringBuffer();
      if (colorHex.length == 6 || colorHex.length == 7) buffer.write('ff');
      buffer.write(colorHex.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (_) {
      return const Color(0xFFFF7A00);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconName': iconName,
      'colorHex': colorHex,
      'completedDates': completedDates
          .map((d) => DateTime(d.year, d.month, d.day).toIso8601String())
          .toList(),
      'currentStreak': currentStreak,
      'bestStreak': bestStreak,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    final rawDates = (json['completedDates'] as List<dynamic>?) ?? [];
    final dates = rawDates.map((e) {
      final parsed = DateTime.parse(e as String);
      return DateTime(parsed.year, parsed.month, parsed.day);
    }).toList();

    return Habit(
      id: json['id'] as String,
      name: json['name'] as String,
      iconName: json['iconName'] as String? ?? 'star',
      colorHex: json['colorHex'] as String? ?? 'FF7A00',
      completedDates: dates,
      currentStreak: json['currentStreak'] as int? ?? 0,
      bestStreak: json['bestStreak'] as int? ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }
}
