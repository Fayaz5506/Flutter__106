import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../utils/constants.dart';
import '../widgets/settings_modal.dart';
import 'task_list_screen.dart';
import 'habit_list_screen.dart';
import 'streak_summary_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    TaskListScreen(),
    HabitListScreen(),
    StreakSummaryScreen(),
  ];

  void _openSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacings.radiusLg)),
      ),
      builder: (ctx) => const SettingsModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 600;

        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.local_fire_department_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'DailyWin',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                tooltip: provider.isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                icon: Icon(
                  provider.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                ),
                onPressed: () => provider.toggleThemeMode(),
              ),
              IconButton(
                tooltip: 'Settings & Options',
                icon: const Icon(Icons.settings_rounded),
                onPressed: () => _openSettings(context),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: Row(
            children: [
              // Responsive NavigationRail for Tablet / Web (width > 600)
              if (isWideScreen)
                NavigationRail(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  labelType: NavigationRailLabelType.all,
                  leading: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Icon(Icons.bolt_rounded, color: AppColors.primary, size: 28),
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.task_alt_outlined),
                      selectedIcon: Icon(Icons.task_alt_rounded),
                      label: Text('Tasks'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.local_fire_department_outlined),
                      selectedIcon: Icon(Icons.local_fire_department_rounded),
                      label: Text('Habits'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.emoji_events_outlined),
                      selectedIcon: Icon(Icons.emoji_events_rounded),
                      label: Text('Streaks'),
                    ),
                  ],
                ),
              if (isWideScreen) const VerticalDivider(thickness: 1, width: 1),
              // Main Screen Content Area (Centered with Max Width 720 on wide screens)
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isWideScreen ? 720 : double.infinity,
                    ),
                    child: AnimatedSwitcher(
                      duration: AppDurations.normal,
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.03, 0.0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: KeyedSubtree(
                        key: ValueKey<int>(_currentIndex),
                        child: _screens[_currentIndex],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // NavigationBar for Mobile Phones (width <= 600)
          bottomNavigationBar: isWideScreen
              ? null
              : NavigationBar(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.task_alt_outlined),
                      selectedIcon: Icon(Icons.task_alt_rounded),
                      label: 'Tasks',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.local_fire_department_outlined),
                      selectedIcon: Icon(Icons.local_fire_department_rounded),
                      label: 'Habits',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.emoji_events_outlined),
                      selectedIcon: Icon(Icons.emoji_events_rounded),
                      label: 'Streaks',
                    ),
                  ],
                ),
        );
      },
    );
  }
}
