import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/app_provider.dart';
import '../utils/constants.dart';
import '../widgets/streak_badge.dart';

class StreakSummaryScreen extends StatefulWidget {
  const StreakSummaryScreen({super.key});

  @override
  State<StreakSummaryScreen> createState() => _StreakSummaryScreenState();
}

class _StreakSummaryScreenState extends State<StreakSummaryScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();

    _glowAnimation = Tween<double>(begin: 0.96, end: 1.02).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  int _getNextMilestone(int currentStreak) {
    if (currentStreak < 3) return 3;
    if (currentStreak < 7) return 7;
    if (currentStreak < 30) return 30;
    return 100;
  }

  Widget _buildHeroCard({
    required BuildContext context,
    required Habit? topHabit,
    required bool isDark,
    required ThemeData theme,
  }) {
    if (topHabit == null || topHabit.currentStreak == 0) {
      return Container(
        padding: const EdgeInsets.all(AppSpacings.lg),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(AppSpacings.radiusLg),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.local_fire_department_rounded,
              size: 48,
              color: Colors.grey,
            ),
            const SizedBox(height: AppSpacings.sm),
            Text(
              'No Active Streaks Yet',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Complete your daily habits to light up the flame and build your streak!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              ),
            ),
          ],
        ),
      );
    }

    return ScaleTransition(
      scale: _glowAnimation,
      child: Container(
        padding: const EdgeInsets.all(AppSpacings.lg),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? AppColors.heroGradientDark
                : AppColors.heroGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppSpacings.radiusLg),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppSpacings.radiusLg),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.emoji_events_rounded, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'TOP CURRENT STREAK',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.local_fire_department_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ],
            ),
            const SizedBox(height: AppSpacings.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '${topHabit.currentStreak}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 56,
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  topHabit.currentStreak == 1 ? 'DAY STREAK' : 'DAYS STREAK',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              topHabit.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacings.sm),
            Row(
              children: [
                const Icon(Icons.bolt_rounded, color: Colors.amberAccent, size: 18),
                const SizedBox(width: 4),
                Text(
                  'Keep it going! Best streak: ${topHabit.bestStreak} days',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final topHabit = provider.longestStreakHabit;
    final habits = List<Habit>.from(provider.habits)
      ..sort((a, b) => b.currentStreak.compareTo(a.currentStreak));

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bestStreakEver = provider.bestStreakEver;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Top Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacings.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Streak Summary',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Track your momentum and milestone achievements.',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontSize: 14,
                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Hero Highlight Card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacings.lg),
                child: _buildHeroCard(
                  context: context,
                  topHabit: topHabit,
                  isDark: isDark,
                  theme: theme,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacings.lg),
            ),
            // Overall Stats Row
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacings.lg),
                child: Row(
                  children: [
                    _buildStatCard(
                      context: context,
                      title: 'Total Checks',
                      value: '${provider.totalHabitCompletions}',
                      icon: Icons.check_circle_outline_rounded,
                      color: AppColors.secondary,
                    ),
                    const SizedBox(width: AppSpacings.sm),
                    _buildStatCard(
                      context: context,
                      title: 'Active Habits',
                      value: '${provider.activeHabitsCount}',
                      icon: Icons.star_outline_rounded,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppSpacings.sm),
                    _buildStatCard(
                      context: context,
                      title: 'Best Streak',
                      value: '$bestStreakEver d',
                      icon: Icons.emoji_events_outlined,
                      color: AppColors.priorityMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacings.lg),
            ),
            // Milestone Badges Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacings.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Milestone Trophies',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacings.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildMilestoneBadge(
                          context: context,
                          label: 'Bronze',
                          daysReq: 3,
                          isUnlocked: bestStreakEver >= 3,
                          iconColor: const Color(0xFFCD7F32),
                        ),
                        _buildMilestoneBadge(
                          context: context,
                          label: 'Silver',
                          daysReq: 7,
                          isUnlocked: bestStreakEver >= 7,
                          iconColor: const Color(0xFFC0C0C0),
                        ),
                        _buildMilestoneBadge(
                          context: context,
                          label: 'Gold',
                          daysReq: 30,
                          isUnlocked: bestStreakEver >= 30,
                          iconColor: const Color(0xFFFFD700),
                        ),
                        _buildMilestoneBadge(
                          context: context,
                          label: 'Diamond',
                          daysReq: 100,
                          isUnlocked: bestStreakEver >= 100,
                          iconColor: const Color(0xFF00E5FF),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacings.lg),
            ),
            // Habits Leaderboard Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacings.lg),
                child: Text(
                  'Habit Rankings & Progress',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacings.sm),
            ),
            // Habits Leaderboard Items or Empty Message
            if (habits.isEmpty)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacings.lg),
                  child: Center(child: Text('No habits found to display leaderboard.')),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacings.lg),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final habit = habits[index];
                      final nextMilestone = _getNextMilestone(habit.currentStreak);
                      final progress = (habit.currentStreak / nextMilestone).clamp(0.0, 1.0);

                      return Container(
                        margin: const EdgeInsets.only(bottom: AppSpacings.sm + 4),
                        padding: const EdgeInsets.all(AppSpacings.md),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCard : AppColors.lightCard,
                          borderRadius: BorderRadius.circular(AppSpacings.radiusMd),
                          border: Border.all(
                            color: isDark ? Colors.white10 : Colors.black.withOpacity(0.06),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '#${index + 1}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                    color: index == 0
                                        ? AppColors.primary
                                        : (isDark ? Colors.white54 : Colors.black45),
                                  ),
                                ),
                                const SizedBox(width: AppSpacings.sm + 4),
                                Expanded(
                                  child: Text(
                                    habit.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                StreakBadge(streak: habit.currentStreak, isCompact: true),
                              ],
                            ),
                            const SizedBox(height: AppSpacings.sm + 4),
                            // Progress bar toward next milestone
                            Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: progress,
                                      minHeight: 6,
                                      backgroundColor: habit.color.withOpacity(0.15),
                                      color: habit.color,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacings.sm),
                                Text(
                                  '${habit.currentStreak}/$nextMilestone d',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? AppColors.textMutedDark
                                        : AppColors.textMutedLight,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: habits.length,
                  ),
                ),
              ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 40),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(AppSpacings.radiusMd),
          border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.06)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                color: isDark ? AppColors.textLight : AppColors.textDark,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestoneBadge({
    required BuildContext context,
    required String label,
    required int daysReq,
    required bool isUnlocked,
    required Color iconColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 72,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: BoxDecoration(
        color: isUnlocked
            ? iconColor.withOpacity(0.12)
            : (isDark ? Colors.white.withOpacity(0.03) : Colors.black.withOpacity(0.03)),
        borderRadius: BorderRadius.circular(AppSpacings.radiusMd),
        border: Border.all(
          color: isUnlocked ? iconColor.withOpacity(0.4) : Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            isUnlocked ? Icons.verified_rounded : Icons.lock_outline_rounded,
            color: isUnlocked ? iconColor : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isUnlocked ? iconColor : Colors.grey,
            ),
          ),
          Text(
            '$daysReq days',
            style: TextStyle(
              fontSize: 9,
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            ),
          ),
        ],
      ),
    );
  }
}
