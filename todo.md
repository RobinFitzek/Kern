# Kern – Development TODO

## Phase 1 — Foundation ✅ COMPLETE

- [x] `pubspec.yaml` with all dependencies (riverpod, drift, health, generative_ai, intl, build toolchain)
- [x] Drift database with `RawEntries` + `DerivedEntries` + `SyncStates` tables
- [x] `HealthConnectService` — permissions + delta-sync fetch methods
- [x] Raw data Riverpod providers (HRV, sleep stages, resting HR, steps)
- [x] `main.dart` with `ProviderScope` + dark-mode MaterialApp shell
- [x] `AndroidManifest.xml` with Health Connect read permissions

### Foundation hardening ✅
- [x] **Deduplication** — `UNIQUE(type, timestamp, sourceName)` + `insertOrIgnore`
- [x] **Device attribution** — `sourceName` (package name) + `sourceRecordId` (HC UUID) per row
- [x] **Delta sync** — `SyncStates` watermark; only fetches new data, 1h overlap for late data
- [x] **DB indexes** — `idx_raw_type_ts` + `idx_derived_ns_key_date`
- [x] **WAL mode** — enabled for read/write concurrency
- [x] **DerivedEntries uniqueness** — `date` column + `UNIQUE(namespace, key, date)`
- [x] **`minSdk = 26`** — Health Connect requires Android 8.0
- [x] **`SyncNotifier`** — full state machine: idle → checkingPermissions → syncing → done/denied/error
- [x] **Sync on app open** — `_AppShell` triggers `initialize()` in `initState`

## Phase 2 — Plugins ✅ COMPLETE

- [x] `derived_keys.dart` — `DerivedNamespace`, `ReadinessKey`, `SleepKey`, `StrainKey`, `AiKey`, `FeedbackKey`
- [x] `rawEntriesBetween()` + `derivedForDateRange()` query methods on `AppDatabase`
- [x] `ReadinessPlugin` — bimodal Physical + Mental scores with Bayesian fusion, Z-score normalization, tanh sigmoid scaling, SRI, ACWR penalty
- [x] `SleepPlugin` — quality score from deep+REM stage minutes (60%) + total duration (40%), timestamp-based duration computation
- [x] `StrainPlugin` — 0-100 from yesterday's steps vs 7-day non-zero-day avg
- [x] `AiPlugin` — Gemini 2.5 Flash integration, daily insight generation, API key settings
- [x] `PluginRunner` — Riverpod Notifier, parallel execution, error isolation, 30-day backfill
- [x] `derived_providers.dart` — UI reader providers for all scores, bimodal scores, components, feedback, calibration, historical data
- [x] `SyncNotifier` updated — calls `pluginRunner.runAll()` + `runBackfill()` after sync

### Algorithm hardening ✅
- [x] **Sleep plugin** — fixed: uses `timestampEnd - timestamp` for duration (was summing stage type codes 1-6)
- [x] **Strain plugin** — fixed: excludes zero-step days from baseline (≥3 non-zero days required)
- [x] **Readiness algorithm** — fixed: `isCalibrating` checks both HRV and sleep (was only HRV)
- [x] **AI plugin** — fixed: preserves cached insight on Gemini error (was overwriting)
- [x] **`PRAGMA optimize`** — runs after initial 30-day backfill

## Phase 3 — App Shell & UI ✅ COMPLETE

- [x] **Plugin Registry System**: `KernPlugin` interface, `PluginSlot` enum, `PluginRegistry`
- [x] **PluginSettings Table**: Persists user preferences for enabled state, slot, and order
- [x] **AppShell & Navigation**: Dynamic bottom navigation (Today, Data, Settings + plugins)
- [x] **DashboardScreen**: Vision-aligned layout — status bar → calibration/scores → insight row → recommendation → trend chart
- [x] **PluginManagerScreen**: UI to toggle plugins on/off and configure dashboard slots
- [x] **DataExplorerScreen**: Timeline chart with fl_chart, aggregated data queries
- [x] **Plugin UI**: Readiness detail (dual rings, component bars), Sleep detail (real stage data), Strain detail (score + info), AI dashboard widget
- [x] **OnboardingScreen**: Health Connect permission flow + calibration notice (7-14 day baseline)
- [x] **SettingsScreen**: Appearance (dark mode, dynamic colors), Health Connect toggle, plugin management, navigation manager
- [x] **Theme system**: Dark-first Material 3, dynamic color support, persisted across restarts

### Dashboard widgets ✅
- [x] **ErrorStateWidget** — unified empty/error/permission-denied/calibrating state component
- [x] **StaleDataBadge** — overlay badge showing sync age, tap to re-sync
- [x] **CalibrationBanner** — HRV days + sleep nights progress, completion %, estimated remaining days
- [x] **RecommendationCard** — AI-generated insight (Gemini) with rule-based fallback
- [x] **HistoricalReadinessChart** — 7/14/30 day readiness trend with fl_chart
- [x] **ReadinessCheckInSheet** — morning self-assessment (soreness, energy, stress sliders)

## Phase 4 — Quality & Polish ✅ COMPLETE

- [x] **All hardcoded/fake data purged** — sleep stages, strain activities, labels all computed from real data
- [x] **Non-functional settings disabled** — toggles properly disabled with "Demnächst verfügbar" labels
- [x] **Theme persisted** — `ThemeModeNotifier` + `DynamicColorNotifier` save to SharedPreferences
- [x] **`intl` added as direct dependency** in pubspec.yaml
- [x] **CODING_GUIDELINES.md** created — bans hardcoded data, dead controls, non-persisted prefs
- [x] **7 unused imports removed** across 6 files
- [x] **Deprecated `activeColor` → `activeTrackColor`** in 3 files
- [x] **All AnimationControllers properly disposed**
- [x] **No `print()` calls** anywhere in `lib/`
- [x] **Zero errors, zero warnings** on `flutter analyze`

## Phase 5 — Tests ✅ COMPLETE

- [x] **`readiness_algorithm_test.dart`** — 53 tests, 99% line coverage
  - scorePos/scoreNeg: all Z-score ranges, asymptotes
  - acwrPenalty: sweet spot, exponential curve, cap
  - zScore: normal, empty, single-value, all-equal, symmetry, outliers
  - coefficientOfVariation: normal, empty, zero-mean, all-equal
  - computeSri: insufficient days, empty, perfect regularity, random
  - physicalScoreObjective: normal, excellent, poor, HRV-missing, both-missing, ACWR penalty
  - mentalScoreObjective: normal, excellent, SRI-missing, HRV-missing, all-missing
  - bayesianFusion: no feedback, wObj=1, wObj=0, extreme bad feedback, neutral feedback
  - compute: integration, calibration, feedback fusion, sub-scores, clamping
  - NightSleepData: totalSleepMins, efficiency, zero timeInBed
- [x] **`sleep_plugin_test.dart`** — 13 tests: stage score, duration score, quality score formula
- [x] **`insight_engine_test.dart`** — 60 tests: all-null, all-good, all-bad, mixed, every category's cascading rules, boundaries
- [x] **`strain_plugin_test.dart`** — 9 tests: ratio-based score with edge cases
- [x] **`widget_test.dart`** — algorithm smoke test
- [x] **139 total tests, all passing**

## Phase 6 — Insights & Onboarding ✅ COMPLETE

- [x] **InsightEngine** — pure Dart 3-insight generator (Erholung, Schlaf, Belastung) with cascading rule priority
- [x] **InsightChip** widget — colored icon + category label + insight text per chip
- [x] **DailyInsightsCard** — ConsumerWidget rendering 3 chips from dailyInsightsProvider
- [x] **DailyInsightsCard integrated into dashboard** — replaces Sleep/Strain header row
- [x] **strainStepsYesterday + strainSteps7dAvg providers** — for insight engine
- [x] **Multi-step onboarding** — 4-page PageView (Welcome → Readiness → AI Coach → Connect)
- [x] **Dead code removed** — DailyCalories, StaleDataOverlay, isCalibrating2, unused `onTap: () {}`
- [x] **Health Connect types trimmed** — 23 → 7 (only types actually used by plugins)
- [x] **PluginSlot.footer removed from sleep/strain** — dead rendering path eliminated
- [x] **BouncingCard onTap fixed** — sleep/strain now navigate to detail screens

## Remaining — v2 / Backlog

- [ ] Multi-source conflict — prefer Garmin package over phone sensors (needs `DataSourcePicker` settings UI)
- [ ] Push notifications — low-readiness alert (< 40), morning check-in reminder (needs Firebase/WorkManager)
- [ ] Supabase auth + cloud backup of Derived Store (not Raw — privacy)
- [ ] iOS / HealthKit support (architecture is already platform-agnostic)
- [ ] Garmin Connect IQ direct integration for richer HRV data
- [ ] Health Connect Changes API (changelog tokens) — replace current watermark approach
- [ ] Background sync via WorkManager when Health Connect adds new data
- [ ] DB integration tests (needs Drift in-memory test setup)
