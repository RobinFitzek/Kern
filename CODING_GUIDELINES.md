# Kern — Coding Guidelines

## ⛔ NEVER: Hardcoded / Fake / Placeholder Data in UI

**This is the #1 rule. Violating it makes the app look broken and untrustworthy.**

### Banned Patterns

```dart
// ❌ BAD — hardcoded labels that don't reflect actual data
child: const Text('Good'),              // IS IT actually good?
child: const Text('Excellent'),         // Is it excellent? Prove it.
child: const Text('Goal not met'),      // Why? What's the goal?

// ❌ BAD — fake data that was never fetched
_buildStageCard(context, 'Awake', '1h 12m', Colors.pinkAccent),   // NOT real data
_buildActivityCard(context, 'Running', '10:30 AM • 45 min', ...), // FAKE

// ❌ BAD — hardcoded descriptive text
const Text('You got the quality sleep needed...'),  // Always says this, never changes

// ❌ BAD — static badge labels
const Text('Optimal building'),   // Says this every time regardless of score
const Text('Cardiovascular load'), // Placeholder
```

### Required Pattern

Every label, badge, description, and metric MUST be computed from actual data fetched from the Derived Store or Raw Store.

```dart
// ✅ GOOD — label computed from actual score
final score = scoreAsync.valueOrNull;
final label = score != null
    ? (score >= 70 ? 'Gut' : score >= 50 ? 'Mittel' : 'Niedrig')
    : '--';

// ✅ GOOD — badge color computed from actual value
final goalMet = totalMinutes >= 420;
final badgeColor = goalMet ? AppTheme.textMint : AppTheme.textPink;
final badgeText = goalMet ? 'Ziel erreicht' : 'Ziel: 7h';

// ✅ GOOD — description generated from data, not hardcoded
final desc = goalMet
    ? 'Du hast genug Schlaf für eine solide Erholung bekommen.'
    : 'Deine Schlafdauer lag unter dem Ziel von 7 Stunden.';

// ✅ GOOD — stages from actual data
final stages = [
  if (deepMins > 0) ('Tief', deepMins, Colors.blueAccent),
  if (remMins > 0) ('REM', remMins, Colors.purpleAccent),
  // ...
];

// ✅ GOOD — no data? Show that honestly
if (stages.isEmpty) {
  return const Text('Keine Schlafphasen-Daten verfügbar');
}
```

### When There Is No Data

Show the honest state. Never invent data or show a fake "good" result.

```dart
// ✅ GOOD
if (score == null) {
  return const ErrorStateWidget(type: ErrorDisplayType.noData);
}
```

## ⛔ NEVER: Non-Functional UI (Dead Controls)

Settings toggles, buttons, and pickers that `onChanged: (val) {}` do nothing are banned.
If a feature isn't implemented yet, hide the control or show a disabled state with a "Coming soon" label.

```dart
// ✅ ACCEPTABLE — feature not built yet
SwitchListTile(
  title: const Text('Bedtime Reminder'),
  subtitle: const Text('Demnächst verfügbar'),
  value: false,
  onChanged: null,  // Disabled — not implemented
);

// ✅ BEST — store the setting, use it
SwitchListTile(
  title: const Text('Bedtime Reminder'),
  value: settings.bedtimeReminder,
  onChanged: (val) => ref.read(settingsProvider.notifier).setBedtimeReminder(val),
);
```

## ⛔ NEVER: Non-Persisted Preferences

Theme mode, navigation order, and user settings MUST survive app restarts via SharedPreferences or the database.

```dart
// ❌ BAD — resets to default every launch
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.light); // Always light on restart
}

// ✅ GOOD — loads from SharedPreferences on init
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.light) {
    _load();
  }
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('theme_mode');
    state = stored == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }
}
```

## Code Style

- **Language:** UI text in German, code comments in English
- **State:** Riverpod with `@riverpod` code generation
- **Widgets:** `ConsumerWidget` / `ConsumerStatefulWidget` for all data-reading widgets
- **Theme:** Always use `AppTheme` color constants. Never hardcode hex colors in widgets.
- **Imports:** Use relative imports within `lib/`. Clean up unused imports.
