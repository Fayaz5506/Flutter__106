import 'package:flutter/material.dart';
import '../models/priority.dart';
import '../utils/constants.dart';

class PriorityTag extends StatelessWidget {
  final Priority priority;

  const PriorityTag({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacings.sm + 2,
        vertical: AppSpacings.xs,
      ),
      decoration: BoxDecoration(
        color: priority.backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacings.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: priority.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacings.xs + 2),
          Text(
            priority.label,
            style: TextStyle(
              color: priority.color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
