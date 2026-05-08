# Kern – Development TODO

## Phase 1 — Foundation ✅ COMPLETE

- [x] `pubspec.yaml` with all dependencies (riverpod, drift, health, generative_ai, build toolchain)
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

### Phase 1 final items ✅
- [x] **`minSdk = 26`** — Health Connect requires Android 8.0 (API 26); was using Flutter default of 21
- [x] **`healthConnectServiceProvider`** — Riverpod provider wiring service to shared DB (`lib/core/services/service_providers.dart`)
- [x] **`SyncNotifier`** — full state machine: idle → checkingPermissions → syncing → done/permissionDenied/error (`lib/core/sync/sync_notifier.dart`)
- [x] **Sync on app open** — `_AppShell` triggers `initialize()` in `initState`; sync status shown live in placeholder UI

## Phase 2 — Plugins ✅ COMPLETE

- [x] `derived_keys.dart` — `DerivedNamespace`, `ReadinessKey`, `SleepKey`, `StrainKey` constants
- [x] `rawEntriesBetween()` added to `AppDatabase` for precise time-window queries
- [x] `ReadinessPlugin` — HRV(40%) + Sleep(35%) + Strain(25%) weighted score; graceful degradation when components missing; calibration detection
- [x] `SleepPlugin` — quality score from deep+REM stage minutes (60%) + total duration (40%)
- [x] `StrainPlugin` — 0-100 from yesterday's steps vs 7-day avg; groups step intervals by calendar day
- [x] `PluginRunner` — Riverpod Notifier, runs all 3 plugins in parallel with per-plugin error isolation
- [x] `derived_providers.dart` — UI reader providers for all scores (readinessScore, sleepScore, strainScore, components, sleepMinutes)
- [x] `SyncNotifier` updated — calls `pluginRunner.runAll()` after sync (fire-and-forget)

### Known edge cases to handle in plugins
- [ ] **Cold start / no baseline** — first 7 days of use: show calibration placeholder, skip readiness score. Write `readiness.status = 'calibrating'` to Derived Store.
- [ ] **Multi-source conflict** — if `rawHrv` returns data from both Garmin and phone: prefer Garmin package (`com.garmin.android.apps.connectmobile`). Needs a `PreferredSourceSettings` table or SharedPreferences entry.
- [ ] **Missing data types** — user may not have HRV data (older Garmin models). Readiness plugin must degrade gracefully: skip HRV component, reweight sleep + strain to 60/40.

## Phase 3 — App Shell & UI ✅ COMPLETE

- [x] **Plugin Registry System**: `KernPlugin` interface, `PluginSlot` enum, `PluginRegistry`
- [x] **PluginSettings Table**: Persists user preferences for enabled state, slot, and order
- [x] **AppShell & Navigation**: Dynamic bottom navigation that includes global fixed pages and navigable plugins
- [x] **DashboardScreen**: Dynamic rendering zones (Header, Main, Footer) populated by registered plugins
- [x] **PluginManagerScreen**: UI to toggle plugins on/off and configure dashboard slots
- [x] **DataExplorerScreen**: Scaffolded basic fixed page
- [x] **Plugin UI Implementations**: `ReadinessFeature`, `SleepFeature`, `StrainFeature` added to shell

## Phase 4 — UI Polish & Missing States
- [ ] Onboarding: Health Connect permission flow + calibration notice
- [ ] Design system refinement: tokens, styling consistency
- [ ] Empty/stale state handling (stale data badge if sync failed)

## Phase 5 — AI Coach
- [ ] Dashboard screen: readiness ring + 3 insight cards + 1 recommendation
- [ ] Onboarding: Health Connect permission flow + calibration notice (7-day baseline)
- [ ] Navigation shell (single screen for v1)

### UI edge cases found
- [ ] **Permission denied state** — show inline prompt to open Health Connect settings, not a crash screen
- [ ] **No data state** — if Derived Store has no score for today, show last known score with a "stale" badge (timestamp)
- [ ] **Multiple data sources visible to user** — settings screen should let user see and pick which device's data is being used

## Phase 4 — AI Coach

- [ ] Gemini API integration (`google_generative_ai`)
- [ ] Context prompt builder: pulls Derived Store snapshot → structured prompt
  - Include: today's readiness score + components, last 7-day trend, sleep duration, strain
- [ ] Daily insight generation on app open (cached per day, regenerated once/day)
- [ ] Handle Gemini API failure gracefully — show last cached insight with age label

### AI considerations
- [ ] **Prompt context size** — Gemini has token limits; Derived Store snapshot must be summarized, not dumped raw. Build a `ContextBuilder` utility.
- [ ] **Offline mode** — if no network, surface the cached insight; never show an error in place of a health insight

## Phase 5 — Polish

- [ ] 7–14 day baseline calibration period with UI progress indicator
- [ ] Low-readiness push notification (< 40 score)
- [ ] Settings screen: preferred data source picker, plugin toggle, calibration reset
- [ ] `VACUUM` / `ANALYZE` after initial 30-day backfill to defragment DB
- [ ] Error states + skeleton loaders for all widgets

## Backlog / v2

- [ ] Supabase auth + cloud backup of Derived Store (not Raw — privacy)
- [ ] iOS / HealthKit support (architecture is already platform-agnostic)
- [ ] Garmin Connect IQ direct integration for richer HRV data
- [ ] Historical readiness chart (last 30 days)
- [ ] Health Connect Changes API (changelog tokens) for even more efficient syncing — replace current watermark approach
- [ ] Background sync via WorkManager when Health Connect adds new data
