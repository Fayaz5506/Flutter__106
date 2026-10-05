# DailyWin Design System & UI/UX Specifications

> Design guidelines and component specification document for recreating DailyWin in Figma.

---

## 1. Design Overview & Principles

DailyWin is designed with an energetic, modern, and motivating Material 3 theme. The goal is to maximize visual reward upon completing tasks and maintaining daily habit streaks.

- **Primary Energy:** Energetic Orange (`#FF7A00`) inspires daily action.
- **Success & Reward:** Fresh Teal (`#00A68C`) provides a calming contrast for finished items and active streaks.
- **Visual Hierarchy:** Generous 16px border radii, subtle card elevation, clear priority color indicators, and micro-animations under 600ms.

---

## 2. Color Palette & Tokens

### Brand & Core Colors
| Role | Color Name | Hex Code | Usage |
|---|---|---|---|
| Primary Seed | Energetic Orange | `#FF7A00` | FAB, active tabs, buttons, streak accents |
| Secondary | Fresh Teal | `#00A68C` | Checkmarks, success states, active chips |
| Light Surface | Warm Off-White | `#FAF9F6` | Light theme scaffold background |
| Dark Surface | Deep Slate | `#0F172A` | Dark theme scaffold background |
| Light Card | Clean White | `#FFFFFF` | Light theme cards & containers |
| Dark Card | Navy Slate | `#1E293B` | Dark theme cards & containers |

### Priority Tag Palette
| Priority | Text Color | Background Color | Visual Cue |
|---|---|---|---|
| **High** | `#EF4444` (Red) | `#FEE2E2` | Red dot indicator |
| **Medium** | `#F59E0B` (Amber) | `#FEF3C7` | Amber dot indicator |
| **Low** | `#10B981` (Green) | `#D1FAE5` | Green dot indicator |

### Streak Flame Progression
- **0–2 Days:** Amber Gold (`#FF9800`)
- **3–6 Days:** Energetic Orange (`#FF7A00`)
- **7–29 Days:** Flame Crimson (`#FF5722`)
- **30+ Days:** Inferno Gold Red (`#D50000`) with glow

---

## 3. Typography System

Powered by Google Fonts:
- **Headings & Titles:** `Plus Jakarta Sans` (Bold/SemiBold, clean geometric hierarchy)
- **Body & Captions:** `Inter` (High legibility, clear UI text)

| Style Token | Font Family | Size / Weight | Line Height |
|---|---|---|---|
| `Headline Large` | Plus Jakarta Sans | 28px / Bold | 34px |
| `Headline Medium` | Plus Jakarta Sans | 22px / Bold | 28px |
| `Title Large` | Plus Jakarta Sans | 18px / 700 | 24px |
| `Title Medium` | Plus Jakarta Sans | 16px / 600 | 22px |
| `Body Large` | Inter | 16px / 400 | 24px |
| `Body Medium` | Inter | 14px / 400 | 20px |
| `Label Medium` | Inter | 12px / 600 | 16px |

---

## 4. UI Components List

1. **Header & Progress Card:**
   - Greeting text ("Good morning 👋") + today's date.
   - Circular progress ring with animated % percentage indicator and "3 of 7 tasks done" subtext.
2. **Task Card (`TaskCard`):**
   - Custom `AnimatedCheck` stroke box on left.
   - Strike-through title text decoration.
   - Due time with clock icon + priority tag chip + overdue alert badge when past due.
   - Swipe-to-delete with undo SnackBar.
3. **Habit Card (`HabitCard`):**
   - Icon avatar with soft background tint.
   - Habit name + flame streak badge (`StreakBadge`).
   - 7-day mini week strip (`WeekStrip`) showing Mon–Sun completion dots.
   - Checkbox trigger with celebratory confetti burst.
4. **Streak Summary Hero Card:**
   - Vibrant gradient card (`#FF7A00` to `#FF3D00`).
   - Big number (e.g. `5 DAYS STREAK`), flame icon, and "Keep it going!" subtext.
   - Pulsing glow animation.
5. **Milestone Badges Grid:**
   - Bronze (3 days), Silver (7 days), Gold (30 days), Diamond (100 days) trophies with locked/unlocked state visuals.

---

## 5. Responsive Behavior

- **Mobile (< 600px):** Single-column layout, bottom M3 `NavigationBar` (3 tabs: Tasks, Habits, Streaks).
- **Tablet / Web (>= 600px):** Side `NavigationRail`, main content centered inside a max-width `720px` container to prevent awkward stretching.
