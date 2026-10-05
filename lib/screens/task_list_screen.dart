import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../utils/constants.dart';
import '../utils/date_formatter.dart';
import '../widgets/task_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/add_task_sheet.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning 👋';
    if (hour < 17) return 'Good afternoon 👋';
    return 'Good evening 👋';
  }

  void _openAddTask(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacings.radiusLg)),
      ),
      builder: (ctx) => const AddTaskSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final tasks = provider.filteredTasks;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final totalCount = provider.totalTasksCount;
    final doneCount = provider.completedTasksCount;
    final progressRatio = provider.taskCompletionRatio;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Top Header: Greeting, Date & Animated Progress Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacings.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getGreeting(),
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormatter.formatDate(DateTime.now()),
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontSize: 14,
                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                      ),
                    ),
                    const SizedBox(height: AppSpacings.md),
                    // Progress Ring / Card Container
                    Container(
                      padding: const EdgeInsets.all(AppSpacings.md),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark
                              ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                              : [const Color(0xFFFFF7ED), const Color(0xFFFFEDD5)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(AppSpacings.radiusMd),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Progress Ring with Animated Value
                          SizedBox(
                            width: 54,
                            height: 54,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                TweenAnimationBuilder<double>(
                                  tween: Tween<double>(begin: 0, end: progressRatio),
                                  duration: AppDurations.normal,
                                  builder: (context, value, child) {
                                    return CircularProgressIndicator(
                                      value: value,
                                      strokeWidth: 6.0,
                                      backgroundColor: AppColors.primary.withOpacity(0.15),
                                      color: AppColors.primary,
                                      strokeCap: StrokeCap.round,
                                    );
                                  },
                                ),
                                Text(
                                  '${(progressRatio * 100).toInt()}%',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacings.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Daily Progress',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '$doneCount of $totalCount tasks done',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  totalCount == 0
                                      ? 'Add tasks to get started today!'
                                      : doneCount == totalCount
                                          ? '🎉 All tasks completed! Amazing work!'
                                          : '${totalCount - doneCount} remaining for today',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacings.md),
                    // Filter Chips (All / Pending / Done)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip(
                            context: context,
                            label: 'All (${provider.totalTasksCount})',
                            filter: TaskFilter.all,
                            current: provider.currentFilter,
                          ),
                          const SizedBox(width: AppSpacings.sm),
                          _buildFilterChip(
                            context: context,
                            label: 'Pending (${provider.totalTasksCount - provider.completedTasksCount})',
                            filter: TaskFilter.pending,
                            current: provider.currentFilter,
                          ),
                          const SizedBox(width: AppSpacings.sm),
                          _buildFilterChip(
                            context: context,
                            label: 'Done (${provider.completedTasksCount})',
                            filter: TaskFilter.done,
                            current: provider.currentFilter,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Tasks List or Empty State
            if (tasks.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyStateWidget(
                  icon: provider.currentFilter == TaskFilter.done
                      ? Icons.task_alt_rounded
                      : Icons.assignment_outlined,
                  title: provider.currentFilter == TaskFilter.done
                      ? 'No Completed Tasks Yet'
                      : 'No Tasks Found',
                  description: provider.currentFilter == TaskFilter.done
                      ? 'Complete some tasks and see them show up here!'
                      : 'You are all clear! Tap "+ Add Task" to create a new task.',
                  actionLabel: 'Add Task',
                  onActionPressed: () => _openAddTask(context),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacings.lg),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final task = tasks[index];
                      return TaskCard(
                        key: ValueKey(task.id),
                        task: task,
                        onEdit: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(AppSpacings.radiusLg),
                              ),
                            ),
                            builder: (ctx) => AddTaskSheet(taskToEdit: task),
                          );
                        },
                      );
                    },
                    childCount: tasks.length,
                  ),
                ),
              ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 80),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddTask(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Task', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildFilterChip({
    required BuildContext context,
    required String label,
    required TaskFilter filter,
    required TaskFilter current,
  }) {
    final isSelected = filter == current;
    final provider = Provider.of<AppProvider>(context, listen: false);

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.primary.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : Colors.grey,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (selected) {
        if (selected) {
          provider.setTaskFilter(filter);
        }
      },
    );
  }
}
