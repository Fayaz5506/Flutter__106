import 'package:intl/intl.dart';

class DateFormatter {
  static final DateFormat _timeFormat = DateFormat('h:mm a');
  static final DateFormat _dateFormat = DateFormat('EEEE, MMM d');
  static final DateFormat _shortDateFormat = DateFormat('MMM d');
  static final DateFormat _storageFormat = DateFormat('yyyy-MM-dd');

  /// Formats a DateTime into time string, e.g. "6:30 PM"
  static String formatTime(DateTime dateTime) {
    return _timeFormat.format(dateTime);
  }

  /// Formats a DateTime into date string, e.g. "Sunday, Oct 4"
  static String formatDate(DateTime dateTime) {
    return _dateFormat.format(dateTime);
  }

  /// Formats a DateTime into short date, e.g. "Oct 4"
  static String formatShortDate(DateTime dateTime) {
    return _shortDateFormat.format(dateTime);
  }

  /// Converts a DateTime into a date-only string for storage (yyyy-MM-dd)
  static String toStorageDate(DateTime dateTime) {
    return _storageFormat.format(dateTime);
  }

  /// Normalizes a DateTime to date-only (00:00:00.000)
  static DateTime dateOnly(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day);
  }

  /// Checks if two DateTimes fall on the exact same date
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Checks if a date is strictly today
  static bool isToday(DateTime dt) {
    return isSameDay(dt, DateTime.now());
  }

  /// Checks if a date is strictly yesterday
  static bool isYesterday(DateTime dt) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(dt, yesterday);
  }

  /// Friendly relative label: "Today", "Yesterday", or "Oct 4"
  static String getRelativeLabel(DateTime dt) {
    if (isToday(dt)) return 'Today';
    if (isYesterday(dt)) return 'Yesterday';
    return formatShortDate(dt);
  }

  /// Checks if a task due time is past due (before current time) and not completed
  static bool isPastDue(DateTime dueTime) {
    return dueTime.isBefore(DateTime.now());
  }
}
