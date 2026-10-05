import 'package:flutter/material.dart';
import '../utils/constants.dart';

enum Priority {
  low,
  medium,
  high;

  String get label {
    switch (this) {
      case Priority.high:
        return 'High';
      case Priority.medium:
        return 'Medium';
      case Priority.low:
        return 'Low';
    }
  }

  Color get color {
    switch (this) {
      case Priority.high:
        return AppColors.priorityHigh;
      case Priority.medium:
        return AppColors.priorityMedium;
      case Priority.low:
        return AppColors.priorityLow;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case Priority.high:
        return AppColors.priorityHighBg;
      case Priority.medium:
        return AppColors.priorityMediumBg;
      case Priority.low:
        return AppColors.priorityLowBg;
    }
  }

  static Priority fromString(String value) {
    switch (value.toLowerCase()) {
      case 'high':
        return Priority.high;
      case 'medium':
        return Priority.medium;
      case 'low':
      default:
        return Priority.low;
    }
  }
}
