# Kern – Project Goal & Architecture

## Vision

Kern is an Android health coaching app that fills the gap left by Bevel (iOS-only). It delivers a single, opinionated readiness score and proactive AI-driven insights to Android users with Garmin wearables, using Health Connect as the data backbone.

The core philosophy: **less data shown, more intelligence applied.** Users see one score, three insights, one recommendation — not a dashboard of raw metrics.

***

## Problem Being Solved

- Bevel (the gold standard for AI health coaching) is iOS/Apple Watch only — no Android support planned
- Android alternatives show raw data without opinionated interpretation
- Garmin users on Android have no equivalent of the "one score that tells you how you feel today" experience
- No existing app combines a plugin-based extensible architecture with a clean, minimal UX

***

## Target User

Android user with a Garmin wearable (Forerunner, Fenix, Vivoactive, etc.) who:
- Cares about recovery, sleep quality, and training readiness
- Wants actionable insights, not chart overload
- Is comfortable granting health data permissions

***

## Core Features (v1)

| Feature | Description | Status |
|---|---|---|
| **Readiness Score** | Bimodal 0–100 (Physical + Mental) via Z-score normalization, tanh sigmoid, Bayesian fusion with morning check-in | ✅ |
| **Sleep Score** | Quality rating from sleep stages (deep, REM, light) with timestamp-based duration | ✅ |
| **Strain Score** | Daily training load from step count vs. 7-day non-zero baseline | ✅ |
| **AI Coach** | Proactive daily insight via Gemini 2.5 Flash — contextual, not a chatbot | ✅ |
| **Dashboard** | One screen: status bar → calibration/scores → insight row → recommendation → trend chart | ✅ |

***

## Architecture

Kern uses a **Unidirectional Data Flow** architecture with two isolated stores.

### Two-Layer Data Model

```
[Health Connect / Garmin]
        ↓ sync on app open
[Raw Store] — append-only, immutable
  └── type: hrv | resting_hr | sleep_deep | sleep_rem | sleep_light | steps
  └── value: double
  └── timestamp: DateTime
  └── source: string

        ↓ Plugin Runner triggers on new raw data
[Plugin Runner] — executes all active plugins in isolation

        ↓ each plugin writes only to its own namespace
[Derived Store]
  ├── readiness.physical_score / readiness.mental_score
  ├── readiness.physical_components / readiness.mental_components
  ├── readiness.acwr / readiness.sri
  ├── strain.daily / strain.steps_yesterday / strain.steps_7d_avg
  ├── sleep.quality_score / sleep.deep_minutes / sleep.rem_minutes / sleep.light_minutes
  └── ai.todays_insight (title + text in JSON metadata)

        ↓
[UI Layer] — reads only from Derived Store, never Raw Store directly
```

### Plugin Rules

- Plugins **read** from Raw Store only
- Plugins **write** to Derived Store only, in their own namespace
- Plugins **never** communicate with each other directly
- A disabled plugin simply stops writing — no cascade failures
- UI reads Derived Store keys and shows `ErrorStateWidget` fallback if a key is missing

This mirrors how VS Code and Obsidian handle plugins: no plugin knows about other plugins, only about the shared data layer.

***

## Tech Stack

| Layer | Technology | Reason |
|---|---|---|
| Framework | Flutter (Dart 3.11) | Cross-platform (Android now, iOS later), strong health package |
| State / Plugins | flutter_riverpod + riverpod_annotation | Providers map 1:1 to plugins, built-in unidirectional flow, code generation |
| Local DB | Drift (SQLite ORM) + WAL | Type-safe, compile-time checked, perfect for two-layer store, concurrent reads/writes |
| Health Data | health: ^11.x | Wraps Health Connect + HealthKit in one API |
| AI Coach | google_generative_ai | Gemini 2.5 Flash API for contextual daily insights |
| Charts | fl_chart | Readiness trend line charts (7/14/30 day) |
| Theme | dynamic_color + Material 3 | Dark-first with wallpaper-based dynamic colors |
| Preferences | shared_preferences | Theme mode, dynamic color, API key, onboarding state, settings |

***

## Project Structure

```
lib/
├── core/
│   ├── database/            # Drift DB — Raw + Derived + Sync + PluginSettings + UserFeedback
│   ├── plugins/             # Plugin interfaces + registry + configurator
│   ├── services/            # HealthConnectService + service_providers
│   ├── sync/                # SyncNotifier state machine
│   ├── navigation/          # NavigationState (persisted nav order)
│   └── data/                # DataTypeConfig, aggregation helpers
├── plugins/
│   ├── raw/                 # Raw data Riverpod providers
│   ├── readiness/           # ReadinessPlugin + ReadinessAlgorithm (pure Dart, no Flutter)
│   ├── sleep/               # SleepPlugin
│   ├── strain/              # StrainPlugin
│   ├── ai/                  # AiPlugin (Gemini)
│   ├── derived/             # Derived Store reader providers
│   └── plugin_runner.dart   # Orchestrator — parallel execution + backfill
├── ui/
│   ├── dashboard/           # DashboardScreen + DashboardSkeleton
│   ├── data/                # DataExplorerScreen + TimelineChart + TimelineNavigator
│   ├── onboarding/          # OnboardingScreen + OnboardingProvider
│   ├── plugins/             # PluginManagerScreen
│   ├── settings/            # Settings, Appearance, Navigation screens
│   ├── theme/               # AppTheme (persisted dark/light + dynamic color)
│   └── widgets/             # Shared widgets (ErrorState, StaleData, Calibration, Recommendation, HistoricalChart, BouncingCard, CheckInSheet)
└── main.dart
```

***

## Readiness Score Algorithm (v2 — Bimodal + Bayesian)

### Physical Readiness (R_phys)

Weighted Z-score composite with tanh sigmoid mapping (0–100):

| Component | Weight | Source | Mapping |
|---|---|---|---|
| HRV (RMSSD) | 35% | Nightly average vs. 28-day baseline | scorePos(Z) |
| Resting HR | 20% | Nightly average vs. 28-day baseline | scoreNeg(Z) |
| Deep Sleep | 20% | Tonight's deep sleep minutes vs. baseline | scorePos(Z) |
| Total Sleep Time | 15% | Tonight's TST vs. baseline | scorePos(Z) |
| ACWR Penalty | -10% | 7-day / 28-day active calorie ratio | Exponential penalty (max 25) |

When HRV data is missing (older Garmin models), weights redistribute: RHR→30%, Deep→35%, TST→25%.

### Mental Readiness (R_ment)

| Component | Weight | Source | Mapping |
|---|---|---|---|
| REM Sleep | 30% | Tonight's REM minutes vs. baseline | scorePos(Z) |
| Sleep Regularity Index | 30% | Minute-epoch bitmap, ≥14 days (Phillips 2017) | Linear: -100..+100 → 0..100 |
| HRV Stability (CV) | 20% | 7-day coefficient of variation vs. 28-day | scoreNeg(Z) |
| Sleep Efficiency | 20% | TST / Time-in-Bed (WASO proxy) | Linear: 0..1 → 0..100 |

When SRI is unavailable (<14 days), REM weight increases to 50%. When HRV is missing, CV weight shifts to Efficiency (50%).

### Bayesian Fusion

```
R_final = w_obj × R_obj + (1-w_obj) × R_subj
```

- `w_obj` starts at 0.8 (trusts sensors 80%), adapts as feedback accumulates
- Subjective input from morning check-in: Soreness (1-10), Energy (1-10), Stress (1-10)
- No feedback → pure objective mode (w_obj = 1.0)

### Calibration

- Requires ≥7 HRV data points AND ≥3 sleep nights
- CalibrationBanner shows progress per data type with estimated remaining days
- `isCalibrating` flag written to Derived Store

***

## Milestones

### Phase 1 — Foundation ✅
- [x] Flutter project scaffolded with full dependency setup
- [x] Drift DB with Raw + Derived + Sync + PluginSettings + UserFeedback tables
- [x] HealthConnectService with 23 data type permissions + delta-sync
- [x] Raw data Riverpod providers

### Phase 2 — Plugins ✅
- [x] Readiness score plugin (bimodal v2 with Bayesian fusion)
- [x] Sleep score plugin (timestamp-based duration)
- [x] Strain score plugin (non-zero-day baseline)
- [x] AI coach plugin (Gemini 2.5 Flash)
- [x] Plugin Runner with parallel execution + error isolation + 30-day backfill

### Phase 3 — App Shell & UI ✅
- [x] Dashboard screen — vision-aligned: status bar → calibration/scores → insight row → recommendation → trend chart
- [x] Design system — dark-first Material 3 with dynamic color, persisted theme
- [x] Onboarding — Health Connect permission flow + calibration notice
- [x] Plugin registry + manager + bottom navigation
- [x] Data explorer with fl_chart timeline

### Phase 4 — AI Coach + Polish ✅
- [x] Gemini integration with API key settings
- [x] Daily insight generation on app open (cached per day, preserved on error)
- [x] Baseline calibration period with UI progress indicator (CalibrationBanner)
- [x] Settings + plugin toggle UI
- [x] ErrorStateWidget — unified empty/error/permission-denied/calibrating states
- [x] StaleDataBadge — sync age overlay with tap-to-resync

### Phase 5 — Quality + Tests ✅
- [x] All hardcoded/fake data purged
- [x] Non-functional settings properly disabled
- [x] Theme persisted across restarts
- [x] CODING_GUIDELINES.md
- [x] 79 tests, 99% coverage on core algorithm, zero warnings

### Phase 6 — v2 / Backlog
- [ ] Push notifications for low readiness (<40)
- [ ] Multi-source data source picker (prefer Garmin)
- [ ] Supabase cloud backup
- [ ] iOS / HealthKit support
- [ ] Garmin Connect IQ direct integration
- [ ] Background sync via WorkManager
- [ ] DB integration tests

***

## Design Principles

- **One score, not ten.** Complexity is hidden in the algorithm, not exposed to the user.
- **Proactive, not reactive.** The AI coach speaks first — the user doesn't have to ask.
- **Plugin isolation.** Features are independent. Breaking one never breaks another.
- **Android-first, iOS-ready.** Architecture and data layer are platform-agnostic from day one.
- **Privacy-local.** All computation happens on-device. Raw health data never leaves the phone in v1.
- **No hardcoded data.** Every label, badge, and metric is computed from actual data. See CODING_GUIDELINES.md.
- **Tested algorithms.** Core scoring has 79 tests with 99% line coverage. Algorithm changes require test updates.
