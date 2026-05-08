# Kern – Project Goal & Architecture

## Vision

Kern is an Android health coaching app that fills the gap left by Bevel (iOS-only). It delivers a single, opinionated readiness score and proactive AI-driven insights to Android users with Garmin wearables, using Health Connect as the data backbone.

The core philosophy: **less data shown, more intelligence applied.** Users see one score, three insights, one recommendation — not a dashboard of raw metrics.

***

## Problem Being Solved

- Bevel (the gold standard for AI health coaching) is iOS/Apple Watch only — no Android support planned
- Android alternatives (ONVY, Radiant Health) show raw data without opinionated interpretation
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

| Feature | Description |
|---|---|
| **Readiness Score** | Single 0–100 score computed from HRV baseline, resting HR, sleep quality, and strain |
| **Sleep Score** | Quality rating from sleep stages (deep, REM, light) |
| **Strain Score** | Daily training load from activity + HR data |
| **AI Coach** | Proactive daily insight via Gemini — contextual, not a chatbot |
| **Dashboard** | One screen: score + 3 insights + 1 recommendation |

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
  ├── readiness.score
  ├── readiness.components (hrv_contribution, sleep_contribution, strain_contribution)
  ├── strain.daily
  ├── sleep.quality_score
  └── ai.todays_insight

        ↓
[UI Layer] — reads only from Derived Store, never Raw Store directly
```

### Plugin Rules

- Plugins **read** from Raw Store only
- Plugins **write** to Derived Store only, in their own namespace
- Plugins **never** communicate with each other directly
- A disabled plugin simply stops writing — no cascade failures
- UI reads Derived Store keys and shows fallback (`null` state) if a key is missing

This mirrors how VS Code and Obsidian handle plugins: no plugin knows about other plugins, only about the shared data layer.

***

## Tech Stack

| Layer | Technology | Reason |
|---|---|---|
| Framework | Flutter (Dart) | Cross-platform (Android now, iOS later), strong health package |
| State / Plugins | flutter_riverpod | Providers map 1:1 to plugins, built-in unidirectional flow |
| Local DB | Drift (SQLite ORM) | Type-safe, compile-time checked, perfect for two-layer store |
| Health Data | health: ^11.x | Wraps Health Connect + HealthKit in one API |
| AI Coach | google_generative_ai | Gemini API for contextual daily insights |
| Backend (optional) | Supabase | Auth + cloud backup in v2 |

***

## Project Structure

```
lib/
├── core/
│   ├── database/         # Drift DB — Raw + Derived tables
│   └── services/         # HealthConnectService
├── plugins/
│   ├── raw/              # Raw data Riverpod providers
│   ├── readiness/        # Readiness score plugin
│   ├── sleep/            # Sleep score plugin
│   ├── strain/           # Strain score plugin
│   └── ai/               # AI coach plugin
├── ui/
│   ├── dashboard/        # Main screen
│   └── shared/           # Shared widgets, theme
└── main.dart
```

***

## Readiness Score Algorithm (v1)

The readiness score is a weighted composite:

- **HRV contribution (40%):** Current 7-day HRV average vs. personal 30-day baseline. Above baseline = positive signal.
- **Sleep contribution (35%):** Deep + REM minutes as percentage of optimal (90 min deep, 90 min REM). Sleep duration factor included.
- **Strain contribution (25%):** Yesterday's training load relative to 7-day average. High strain yesterday = lower readiness today.

Score range: 0–100. Above 70 = green (ready). 40–70 = yellow (moderate). Below 40 = red (rest day).

***

## Milestones

### Phase 1 — Foundation ✅
- [x] Flutter project scaffolded with full dependency setup
- [x] Drift DB with Raw + Derived tables
- [x] HealthConnectService with HRV, sleep, HR permissions + fetch methods
- [x] Raw data Riverpod providers

### Phase 2 — Plugins
- [ ] Readiness score plugin (algorithm v1)
- [ ] Sleep score plugin
- [ ] Strain score plugin
- [ ] Plugin Runner that triggers on sync

### Phase 3 — UI
- [ ] Dashboard screen (score + insights)
- [ ] Minimal design system (dark-first, one accent color)
- [ ] Onboarding + Health Connect permission flow

### Phase 4 — AI Coach
- [ ] Gemini integration
- [ ] Context prompt builder (pulls from Derived Store)
- [ ] Daily insight generation on app open

### Phase 5 — Polish
- [ ] Baseline calibration period (7–14 days)
- [ ] Notifications for low readiness
- [ ] Settings + plugin toggle UI

***

## Design Principles

- **One score, not ten.** Complexity is hidden in the algorithm, not exposed to the user.
- **Proactive, not reactive.** The AI coach speaks first — the user doesn't have to ask.
- **Plugin isolation.** Features are independent. Breaking one never breaks another.
- **Android-first, iOS-ready.** Architecture and data layer are platform-agnostic from day one.
- **Privacy-local.** All computation happens on-device. Raw health data never leaves the phone in v1.
