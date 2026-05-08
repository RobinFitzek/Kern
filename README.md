# Kern 🧬

A modular, extensible health coaching app for Android. Kern uses a plugin-based architecture and integrates seamlessly with Health Connect to provide personalized readiness, sleep, and strain metrics.

## 📥 Installation (Android)

You do not need to build the app from source to try it out!

1. Go to the [releases folder](releases/) in this repository.
2. Download the latest `kern-latest.apk` to your Android phone.
3. Open the downloaded file to install it. *(You may need to allow "Install unknown apps" from your browser/file manager).*
4. On the first launch, Kern will request access to **Health Connect**. Please grant these permissions to allow the app to read your health data.

---

## 🏗️ Architecture

Kern is designed around a "Shell + Plugins" concept, similar to VS Code or Photoshop. The core app itself contains **no health logic**. Everything is driven by plugins.

### The Shell
- **Dashboard:** A dynamic UI shell with `header`, `main`, and `footer` zones. It renders whatever the active plugins provide.
- **Data Explorer:** A raw view of all synchronized health data.
- **Plugin Manager:** Allows users to toggle plugins on/off and rearrange their dashboard positions dynamically.

### The Data Flow
1. **Raw Store (SQLite):** An append-only, immutable database. The `SyncNotifier` fetches delta updates from Google Health Connect (Steps, HRV, Sleep stages, Resting HR) and writes them here.
2. **Plugin Runner:** After every sync, all enabled plugins run in parallel. They read from the Raw Store, apply their specific algorithms, and output derived metrics.
3. **Derived Store (SQLite):** A key-value store where plugins save their computed results (e.g., `readiness.score = 85`).
4. **UI Layer:** The dashboard simply reads from the Derived Store via Riverpod providers. It never computes data on the fly.

---

## 🧩 Plugins

Kern currently ships with three core plugins:

*   **Readiness:** Computes a daily 0-100 score based on a weighted algorithm of your 7-day HRV average vs baseline (40%), Sleep stages vs optimal (35%), and yesterday's Strain (25%). It gracefully degrades if certain data (like HRV) is missing from your wearable.
*   **Sleep:** Calculates a sleep quality score based on Deep + REM stage duration vs total sleep duration.
*   **Strain:** Calculates physical exertion based on daily step counts relative to your 7-day average baseline.

### Writing a new Plugin

To add a new feature (like an AI Coach or a Hydration Tracker), simply:
1. Create a class that implements `KernPlugin`.
2. Define your `id`, `name`, and `supportedSlots`.
3. Provide UI widgets via `buildDashboardWidget()` or `buildDetailPage()`.
4. Register it in `main.dart` with `PluginRegistry.register(YourPlugin())`.

---

## 🛠️ Tech Stack
- **Framework:** Flutter (Dart)
- **State Management:** Riverpod (`riverpod_annotation`)
- **Local Database:** Drift (SQLite with WAL enabled for concurrent reads/writes)
- **Health Integration:** `health` package (Google Health Connect)

## 💻 Local Development

1. Ensure you have the Flutter SDK installed.
2. Clone the repository: `git clone https://github.com/RobinFitzek/Kern.git`
3. Enter the flutter project directory: `cd Kern/kern`
4. Install dependencies: `flutter pub get`
5. Run code generation for Drift and Riverpod: `dart run build_runner build --delete-conflicting-outputs`
6. Run the app on a connected Android device: `flutter run`
