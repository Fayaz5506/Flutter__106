import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/app_provider.dart';
import '../utils/constants.dart';
import '../utils/date_formatter.dart';
import 'animated_check.dart';
import 'priority_tag.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  final VoidCallback onEdit;

  const TaskCard({
    super.key,
    required this.task,
    required this.onEdit,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _isStrikingThrough = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final isPastDue = DateFormatter.isPastDue(widget.task.dueTime) && !widget.task.isDone;

    return Dismissible(
      key: Key(widget.task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacings.lg),
        decoration: BoxDecoration(
          color: AppColors.priorityHigh,
          borderRadius: BorderRadius.circular(AppSpacings.radiusMd),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 28),
      ),
      onDismissed: (_) {
        final taskToRestore = widget.task;
        final index = provider.tasks.indexOf(widget.task);
        provider.deleteTask(widget.task.id);

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task "${taskToRestore.title}" deleted'),
            action: SnackBarAction(
              label: 'Undo',
              textColor: AppColors.primary,
              onPressed: () {
                provider.restoreTask(taskToRestore, index);
              },
            ),
          ),
        );
      },
      child: AnimatedContainer(
        duration: AppDurations.normal,
        margin: const EdgeInsets.only(bottom: AppSpacings.sm + 4),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(AppSpacings.radiusMd),
          border: Border.all(
            color: widget.task.isDone
                ? AppColors.secondary.withOpacity(0.3)
                : isPastDue
                    ? AppColors.priorityHigh.withOpacity(0.4)
                    : (isDark ? Colors.white10 : Colors.black.withOpacity(0.06)),
            width: isPastDue || widget.task.isDone ? 1.5 : 1.0,
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
          onTap: widget.onEdit,
          borderRadius: BorderRadius.circular(AppSpacings.radiusMd),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacings.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Animated Checkbox
                AnimatedCheck(
                  checked: widget.task.isDone,
                  activeColor: AppColors.secondary,
                  onAnimationDone: () {
                    // Called ONLY after checkmark animation completes (450ms)
                    setState(() {
                      _isStrikingThrough = false;
                    });
                    provider.setTaskCompletion(widget.task.id, true);
                  },
                  onUnchecked: () {
                    provider.setTaskCompletion(widget.task.id, false);
                  },
                ),
                const SizedBox(width: AppSpacings.md),
                // Task Content (Title, Due Time, Priority Tag)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title with animated strike-through decoration
                      AnimatedDefaultTextStyle(
                        duration: AppDurations.quick,
                        style: theme.textTheme.titleMedium!.copyWith(
                          decoration: widget.task.isDone || _isStrikingThrough
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationColor: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                          decorationThickness: 2.0,
                          color: widget.task.isDone
                              ? (isDark ? AppColors.textMutedDark : AppColors.textMutedLight)
                              : (isDark ? AppColors.textLight : AppColors.textDark),
                          fontWeight: widget.task.isDone ? FontWeight.normal : FontWeight.w600,
                        ),
                        child: Text(
                          widget.task.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: AppSpacings.xs + 2),
                      Row(
                        children: [
                          // Due Time
                          Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: isPastDue
                                ? AppColors.priorityHigh
                                : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormatter.formatTime(widget.task.dueTime),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isPastDue ? FontWeight.bold : FontWeight.normal,
                              color: isPastDue
                                  ? AppColors.priorityHigh
                                  : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                            ),
                          ),
                          if (isPastDue) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.priorityHighBg,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Overdue',
                                style: TextStyle(
                                  color: AppColors.priorityHigh,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                          const Spacer(),
                          // Priority Tag
                          PriorityTag(priority: widget.task.priority),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
