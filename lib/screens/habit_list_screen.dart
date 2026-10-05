import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../providers/app_provider.dart';
import '../utils/constants.dart';
import '../widgets/habit_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/add_habit_sheet.dart';
import '../widgets/confetti_overlay.dart';

class HabitListScreen extends StatefulWidget {
  const HabitListScreen({super.key});

  @override
  State<HabitListScreen> createState() => _HabitListScreenState();
}

class _HabitListScreenState extends State<HabitListScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _triggerBurst() {
    _confettiController.play();
  }

  void _openAddHabit(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacings.radiusLg)),
      ),
      builder: (ctx) => const AddHabitSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final habits = provider.habits;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Top Header: Title & Habit Summary
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacings.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Habit Tracker',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(AppSpacings.radiusLg),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.bolt_rounded,
                                    color: AppColors.secondary,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${provider.activeHabitsCount} Active',
                                    style: const TextStyle(
                                      color: AppColors.secondary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Build consistency day by day. Every check counts!',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontSize: 14,
                            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Habits List or Empty State
                if (habits.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyStateWidget(
                      icon: Icons.local_fire_department_rounded,
                      title: 'No Habits Created Yet',
                      description: 'Track your daily routines and build uninterrupted streaks. Tap "+ Add Habit" to start!',
                      actionLabel: 'Add Habit',
                      onActionPressed: () => _openAddHabit(context),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacings.lg),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final habit = habits[index];
                          return HabitCard(
                            key: ValueKey(habit.id),
                            habit: habit,
                            onCompletedBurst: _triggerBurst,
                            onEdit: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(AppSpacings.radiusLg),
                                  ),
                                ),
                                builder: (ctx) => AddHabitSheet(habitToEdit: habit),
                              );
                            },
                          );
                        },
                        childCount: habits.length,
                      ),
                    ),
                  ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 80),
                ),
              ],
            ),
          ),
          // Confetti overlay when habit is completed
          ConfettiOverlayWidget(controller: _confettiController),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddHabit(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Habit', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
