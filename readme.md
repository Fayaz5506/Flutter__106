# DailyWin: Smart To-Do & Habit Tracker

> A production-grade Flutter application combining task management and recurring habit tracking into a unified experience with custom checkmark stroke animations, loop-based streak calculations, local JSON persistence, and a responsive Material 3 design system.

![Flutter](https://img.shields.io/badge/Flutter-3.47-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.13-0175C2?logo=dart)
![Material 3](https://img.shields.io/badge/Material--3-useMaterial3-6750A4)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20macOS-green)
![License](https://img.shields.io/badge/License-MIT-blue)

---

## Table of Contents

1. [Overview & Objective](#1-overview--objective)
2. [Problem & Solution](#2-problem--solution)
3. [Full Feature Breakdown](#3-full-feature-breakdown)
4. [Tech Stack & Package Rationale](#4-tech-stack--package-rationale)
5. [Architecture & Project Structure](#5-architecture--project-structure)
6. [Data Schemas & Local Storage](#6-data-schemas--local-storage)
7. [Core Algorithms & Deep Dive](#7-core-algorithms--deep-dive)
   - [7.1 Custom Checkmark & Strike-Through Animation](#71-custom-checkmark--strike-through-animation)
   - [7.2 Loop-Based Streak Calculation](#72-loop-based-streak-calculation)
   - [7.3 Hero Highlight & Milestone Logic](#73-hero-highlight--milestone-logic)
8. [Design System & UI/UX](#8-design-system--uiux)
9. [Responsive Layout Strategy](#9-responsive-layout-strategy)
10. [Getting Started & Installation](#10-getting-started--installation)
11. [Testing & Quality Verification](#11-testing--quality-verification)
12. [Deliverables Checklist](#12-deliverables-checklist)

---

## 1. Overview & Objective

**DailyWin** is designed to solve daily productivity friction by combining single-instance tasks with recurring habit tracking in a single, beautiful app. 

### Key Goals Met:
- **Visual Reward System:** Tapping a checkmark plays a 450ms custom stroke draw animation with a title strike-through **before** state changes.
- **Streak Accountability:** Recurring habits calculate current & best streaks using explicit loop algorithms over date history (`completedDates`).
- **Motivation Dashboard:** The Streak Summary screen spotlights the habit with the longest active streak with gradient lighting, pulsing animations, and milestone trophies.
- **Full Offline Persistence:** All tasks, habits, streak history, and theme settings persist locally via `shared_preferences` with JSON encoding.
- **Zero-Bug Quality:** Verified with 0 `flutter analyze` issues and 100% passing unit and widget tests.

---

## 2. Problem & Solution

| Problem | DailyWin Solution |
|---|---|
| Users split tasks and habits across different apps and lose momentum | Single unified app with dedicated tabs for **Tasks**, **Habits**, and **Streak Summary** |
| Accidental taps instantly toggle completion without visual feedback | CustomPainter checkbox draws stroke over 450ms; task is marked done **only after** completion |
| Habit streak counts get out of sync upon app restarts or date changes | Streaks are dynamically calculated from a set of completion dates (`completedDates`) using deterministic loops |
| Generic grey UI leads to low user engagement | Energetic Orange (`#FF7A00`) and Fresh Teal (`#00A68C`) palette with glowing hero cards and confetti bursts |

---

## 3. Full Feature Breakdown

### A. Task List Screen
- **Smart Greeting Header:** Displays time-based greeting ("Good morning", "Good afternoon", "Good evening") with today's date (e.g. `Sunday, Oct 4`).
- **Animated Progress Ring:** Card displaying percentage completion (e.g. `3 of 7 tasks done`) with smooth `TweenAnimationBuilder` fill.
- **Filter Chips:** Easily toggle between **All**, **Pending**, and **Done** task views with count indicators.
- **Rich Task Cards:** Every card displays:
  - Task title with animated strike-through decoration upon completion.
  - Formatted due time (e.g. `6:30 PM`) with clock icon.
  - Color-coded priority tag chip (**High** = Red, **Medium** = Amber, **Low** = Green).
  - Red **"Overdue"** alert badge if past due and incomplete.
  - Custom stroke-drawing animated checkbox.
- **Swipe-to-Delete with Undo:** Swiping left deletes a task and triggers an interactive SnackBar with an **Undo** action to restore the item.
- **FAB & Edit Modal:** Floating Action Button opens a bottom sheet with title input, time picker, and priority segmented button.

### B. Habit List Screen
- **Habit Cards:** Features habit name, custom icon avatar with color tint, flame streak badge, and 7-day mini week strip.
- **7-Day Mini Week Strip:** Displays completion status for each day of the past week (Mon–Sun) with active color indicators.
- **Confetti Celebration:** Completing a habit triggers a celebratory particle burst (`confetti`) and haptic feedback.
- **Streak Flame Badges:** Flame icon and day count chip; colors warm up dynamically:
  - 0–2 days: Amber Warm (`#FF9800`)
  - 3–6 days: Vibrant Orange (`#FF7A00`)
  - 7–29 days: Crimson Red (`#FF5722`)
  - 30+ days: Inferno Gold (`#D50000`) with glow.

### C. Streak Summary Screen
- **Longest Streak Hero Card:** Spotlight hero card for the habit with the **longest current streak**, featuring an energetic gradient (`#FF7A00` to `#FF3D00`), giant day count, flame icon, and subtle pulsing glow.
- **Overall Stats Row:** Quick statistics summary:
  - Total completions count
  - Active habits count
  - Best streak ever across all habits
- **Milestone Trophies:** Displays unlocked or locked trophy cards for achieving milestones:
  - **Bronze** (3 days)
  - **Silver** (7 days)
  - **Gold** (30 days)
  - **Diamond** (100 days)
- **Habit Leaderboard:** Ranks all habits by active streak with progress bars toward the next milestone target.

### D. General & Settings
- **Theme Mode Switch:** Seamless toggle between Light Mode and Dark Mode.
- **Sample Seed Data:** Pre-populates sample tasks and habit streaks on first launch.
- **Data Controls:** Modal options to **Reset Sample Seed Data** or **Clear All Data**.

---

## 4. Tech Stack & Package Rationale

| Dependency | Purpose | Rationale |
|---|---|---|
| **Flutter 3.x / Dart 3.x** | Core Framework | Cross-platform framework with native performance on Android, iOS, Web, and macOS |
| **`provider` (6.1.5)** | State Management | Clean separation of business logic (`ChangeNotifier`) from UI widgets |
| **`shared_preferences` (2.5.5)** | Local Storage | Fast key-value JSON storage without requiring sqlite setup |
| **`google_fonts` (6.3.3)** | Typography | Integrates `Plus Jakarta Sans` for titles and `Inter` for body text |
| **`intl` (0.19.0)** | Date & Time Formatting | Standardized formatting for dates (`Sunday, Oct 4`) and times (`6:30 PM`) |
| **`uuid` (4.6.0)** | ID Generation | Generates unique IDs for tasks and habits |
| **`confetti` (0.7.0)** | Visual Effects | Lightweight particle explosion on habit completion |

---

## 5. Architecture & Project Structure

Organized cleanly into modular packages:

```
lib/
├── main.dart                  # App entry point, Provider setup, MaterialApp config
├── theme/
│   └── app_theme.dart         # Material 3 light & dark themes, color schemes, typography
├── models/
│   ├── task.dart              # Task model, Priority enum relation, JSON serialization
│   ├── habit.dart             # Habit model, completedDates array, JSON parsing
│   └── priority.dart          # Priority enum (High, Medium, Low) & color helpers
├── services/
│   └── storage_service.dart   # SharedPreferences persistence & initial seed data
├── logic/
│   └── streak_calculator.dart # Pure loop-based algorithms for current & best streak calculation
├── providers/
│   └── app_provider.dart      # ChangeNotifier handling tasks, habits, filters, & settings
├── screens/
│   ├── splash_screen.dart     # Startup splash screen with animated branding
│   ├── main_screen.dart       # Responsive shell with bottom NavigationBar / NavigationRail
│   ├── task_list_screen.dart  # Task list, greeting header, progress ring, and filter chips
│   ├── habit_list_screen.dart # Habit cards list, week strip, and confetti overlay
│   └── streak_summary_screen.dart # Longest streak hero card, trophies, and leaderboard
├── widgets/
│   ├── animated_check.dart    # CustomPainter checkmark stroke draw animation
│   ├── task_card.dart         # Task item card with overdue badge & swipe-to-delete
│   ├── habit_card.dart        # Habit item card with icon avatar, badge & week strip
│   ├── priority_tag.dart      # Color-coded priority tag chip
│   ├── streak_badge.dart      # Flame icon & day count badge with color warming
│   ├── week_strip.dart        # 7-day mini week strip for habits
│   ├── confetti_overlay.dart  # Confetti burst animation overlay
│   ├── empty_state.dart       # Illustration empty state view
│   ├── add_task_sheet.dart    # Task creation & editing bottom sheet
│   ├── add_habit_sheet.dart   # Habit creation & editing bottom sheet
│   └── settings_modal.dart    # Theme toggle & data reset options modal
└── utils/
    ├── constants.dart         # Color tokens, spacing grid, animation durations
    └── date_formatter.dart    # Date & time formatting utility methods
```

---

## 6. Data Schemas & Local Storage

All models are serialized to JSON strings and stored under SharedPreferences keys:

### Task Schema JSON:
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "title": "Design DailyWin dashboard",
  "dueTime": "2026-10-04T18:30:00.000",
  "priority": "high",
  "isDone": false,
  "createdAt": "2026-10-04T10:00:00.000"
}
```

### Habit Schema JSON:
```json
{
  "id": "67c87e47-879b-4014-9d2a-73cf93dd638c",
  "name": "Morning Meditation",
  "iconName": "self_improvement",
  "colorHex": "FF7A00",
  "completedDates": [
    "2026-10-01T00:00:00.000",
    "2026-10-02T00:00:00.000",
    "2026-10-03T00:00:00.000",
    "2026-10-04T00:00:00.000"
  ],
  "currentStreak": 4,
  "bestStreak": 4,
  "createdAt": "2026-10-01T08:00:00.000"
}
```

---

## 7. Core Algorithms & Deep Dive

### 7.1 Custom Checkmark & Strike-Through Animation
In `lib/widgets/animated_check.dart`, tapping a task triggers a 450ms `AnimationController`:
1. `CustomPainter` (`_CheckPainter`) receives `progress` from 0.0 to 1.0.
2. Background circle fill expands from center.
3. The checkmark path (defined by 3 anchor points) draws progressively:
   - Progress 0.0–0.4: Draws the downward stroke (`p1` to `p2`).
   - Progress 0.4–1.0: Draws the upward check stroke (`p2` to `p3`).
4. An `AnimationStatus.completed` listener executes `widget.onAnimationDone()` **only when** the animation finishes.
5. In sync, the title text applies a `TextDecoration.lineThrough` with smooth transition.

### 7.2 Loop-Based Streak Calculation
In `lib/logic/streak_calculator.dart`:

```dart
/// Current streak = consecutive completed days ending today (or yesterday if today isn't done yet)
static int calculateCurrentStreak(List<DateTime> completedDates, {DateTime? relativeTo}) {
  if (completedDates.isEmpty) return 0;
  
  // Normalize completed dates to date-only set (YYYY-MM-DD)
  final Set<String> dateSet = completedDates
      .map((d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}')
      .toSet();

  final now = relativeTo ?? DateTime.now();
  DateTime cursor = DateTime(now.year, now.month, now.day);
  String cursorKey = _formatKey(cursor);

  // If today is not done yet, check if yesterday was done to keep streak alive
  if (!dateSet.contains(cursorKey)) {
    cursor = cursor.subtract(const Duration(days: 1));
    cursorKey = _formatKey(cursor);
  }

  int streak = 0;
  // Loop backwards day by day while date exists in set
  while (dateSet.contains(cursorKey)) {
    streak++;
    cursor = cursor.subtract(const Duration(days: 1));
    cursorKey = _formatKey(cursor);
  }
  return streak;
}

/// Best streak = longest run of consecutive days in history
static int calculateBestStreak(List<DateTime> completedDates) {
  if (completedDates.isEmpty) return 0;
  
  final sorted = completedDates
      .map((d) => DateTime(d.year, d.month, d.day))
      .toSet()
      .toList()
    ..sort();

  int maxStreak = 0;
  int currentRun = 0;

  for (int i = 0; i < sorted.length; i++) {
    if (i == 0) {
      currentRun = 1;
    } else {
      final diff = sorted[i].difference(sorted[i - 1]).inDays;
      if (diff == 1) {
        currentRun++;
      } else if (diff > 1) {
        currentRun = 1;
      }
    }
    if (currentRun > maxStreak) maxStreak = currentRun;
  }
  return maxStreak;
}
```

---

## 8. Design System & UI/UX

- **Color Tokens:**
  - Seed / Primary: Energetic Orange (`#FF7A00`)
  - Secondary / Success: Fresh Teal (`#00A68C`)
  - Light Background: Soft warm off-white (`#FAF9F6`)
  - Dark Background: Deep slate navy (`#0F172A`)
- **Typography:** Headings in `Plus Jakarta Sans`, body text in `Inter`.
- **Card Styling:** 16px corner radius, soft borders, subtle drop shadows.

---

## 9. Responsive Layout Strategy

Built using `LayoutBuilder` in `lib/screens/main_screen.dart`:
- **Mobile Phones (`width <= 600px`):** Single-column scroll layout with bottom Material 3 `NavigationBar`.
- **Tablets & Web (`width > 600px`):** Left-side `NavigationRail` with main screen content centered inside a max-width `720px` container to prevent wide stretching.

---

## 10. Getting Started & Installation

### Prerequisites:
- Flutter SDK 3.x
- Dart SDK 3.x
- Google Chrome or mobile emulator

### Steps:
```bash
# 1. Clone repository & navigate to folder
git clone <your-repo-url>
cd dailywin

# 2. Get dependencies
flutter pub get

# 3. Run static analyzer
flutter analyze

# 4. Run test suite
flutter test

# 5. Launch app on Chrome
flutter run -d chrome
```

---

## 11. Testing & Quality Verification

### Unit Tests (`test/streak_calculator_test.dart`):
- `Empty list returns 0 for current and best streak`
- `Consecutive days up to today calculates correct current streak`
- `Streak stays alive when today is not completed yet but yesterday was`
- `Gap in completion resets current streak`
- `Best streak retains historical maximum run`
- `Handles duplicate dates on same day gracefully`
- `isCompletedOnDate returns true only for matching dates`

### Widget Tests (`test/widget_test.dart`):
- `DailyWin main screen renders greeting header and navigation tabs`

---

## 12. Deliverables Checklist

- [x] Complete Flutter project running on Web, Mobile, and Desktop.
- [x] Material 3 design system with light/dark theme toggle.
- [x] Custom checkmark stroke draw animation & strike-through text.
- [x] Loop-based streak calculation and history persistence.
- [x] Comprehensive unit and widget test suite passing cleanly.
- [x] Updated, detailed `README.md` and Figma design specification file (`docs/design.md`).