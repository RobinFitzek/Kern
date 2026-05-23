# Kern 🧬

A modular, extensible health coaching app for Android. Kern uses a plugin-based architecture and integrates seamlessly with Health Connect to provide personalized readiness, sleep, and strain metrics.

## 📥 Installation (Android)

You do not need to build the app from source to try it out!

1. Go to the [Releases](https://github.com/RobinFitzek/Kern/releases) section.
2. Download the latest `Kern_v0.2.apk` (or newer).
3. Open the downloaded file to install it. *(You may need to allow "Install unknown apps").*
4. On the first launch, Kern will request access to **Health Connect**.

---

## 🏗️ Architecture
...
### The Shell
...
### The Data Flow
...

---

## 🧩 Plugins

Kern currently ships with four core plugins:

*   **Readiness (v2):** A scientifically rigorous, bimodal scoring system.
    - **Physical Readiness:** Based on HRV (RMSSD), Resting HR, Deep Sleep, and ACWR (Acute:Chronic Workload Ratio). 99% test coverage.
    - **Mental Readiness:** Based on REM Sleep, Sleep Regularity Index (SRI), and HRV Stability (CV).
    - **Bayesian Fusion:** Combines objective wearable data with your subjective **Morning Check-in** feedback.
*   **Sleep:** Calculates a sleep quality score based on Deep + REM stage duration vs total sleep duration.
*   **Strain:** Calculates physical exertion based on daily step counts relative to your 7-day non-zero-day baseline.
*   **AI Coach:** Proactive daily insights via Google Gemini 2.5 Flash. Falls back to rule-based recommendations when offline.

### Writing a new Plugin

To add a new feature (like an AI Coach or a Hydration Tracker), simply:
1. Create a class that implements `KernPlugin`.
2. Define your `id`, `name`, and `supportedSlots`.
3. Provide UI widgets via `buildDashboardWidget()` or `buildDetailPage()`.
4. Register it in `main.dart` with `PluginRegistry.register(YourPlugin())`.

---

## 🛠️ Tech Stack
- **Framework:** Flutter (Dart 3.11)
- **State Management:** Riverpod (`riverpod_annotation`)
- **Local Database:** Drift (SQLite with WAL enabled for concurrent reads/writes)
- **Health Integration:** `health` package (Google Health Connect)
- **AI:** `google_generative_ai` (Gemini 2.5 Flash)
- **Charts:** `fl_chart`
- **Theme:** `dynamic_color` (Material 3 + wallpaper colors)

## 💻 Local Development

1. Ensure you have the Flutter SDK installed.
2. Clone the repository: `git clone https://github.com/RobinFitzek/Kern.git`
3. Enter the flutter project directory: `cd Kern/kern`
4. Install dependencies: `flutter pub get`
5. Run code generation: `dart run build_runner build --delete-conflicting-outputs`
6. Run the app on a connected Android device: `flutter run`
7. Run tests: `flutter test` (79 tests, zero failures)

**Quality checks:** `flutter analyze` (zero errors, zero warnings)
