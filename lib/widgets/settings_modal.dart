import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../utils/constants.dart';

class SettingsModal extends StatelessWidget {
  const SettingsModal({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final theme = Theme.of(context);
    final isDark = provider.isDarkMode;

    return Padding(
      padding: const EdgeInsets.all(AppSpacings.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacings.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Settings & Options',
                style: theme.textTheme.headlineMedium?.copyWith(fontSize: 20),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacings.md),
          // Theme Switch Tile
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                color: AppColors.primary,
              ),
            ),
            title: const Text('Dark Mode Theme', style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(isDark ? 'Dark theme active' : 'Light theme active'),
            trailing: Switch(
              value: isDark,
              activeTrackColor: AppColors.primary,
              onChanged: (_) {
                provider.toggleThemeMode();
              },
            ),
          ),
          const Divider(height: 24),
          // Reset Seed Data
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.restore_rounded, color: AppColors.secondary),
            ),
            title: const Text('Reset Sample Seed Data', style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: const Text('Populates default tasks & habit streaks'),
            onTap: () async {
              await provider.resetToSeedData();
              if (context.mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sample seed data restored successfully!')),
                );
              }
            },
          ),
          // Clear All Data
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.priorityHigh.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.delete_forever_rounded, color: AppColors.priorityHigh),
            ),
            title: const Text('Clear All Local Data', style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: const Text('Wipes tasks, habits, and history'),
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Clear all data?'),
                  content: const Text('This action will delete all tasks and habits permanently.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.priorityHigh),
                      child: const Text('Clear', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await provider.clearAllData();
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All data cleared.')),
                  );
                }
              }
            },
          ),
          const Divider(height: 24),
          // About Section
          Center(
            child: Column(
              children: [
                const Text(
                  'DailyWin v1.0.0',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  'Smart To-Do & Habit Tracker • Flutter 3.x',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacings.md),
        ],
      ),
    );
  }
}
