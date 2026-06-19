# Implementation Plan - Advanced Prayer & Jamat Features

Implement background listening (Siri-like), manual Jamat times, and pre-Jamat overlays with Adhan audio.

## User Review Required

> [!WARNING]
> **Adhan Detection (Listening Mode):** Implementing a Siri-like listening feature for external Adhan requires a Machine Learning model (TFLite) to identify the sound accurately. I will set up the **Audio Infrastructure** and **Background Listener**, but a pre-trained `.tflite` model file will be needed for actual recognition. For now, I will implement a "Simulated Detection" mode for testing.

> [!IMPORTANT]
> **Background Permissions:** On Windows/macOS/Linux, the app must have microphone permissions. I will add the necessary configurations to the project.

## Proposed Changes

### Core Infrastructure & Database

#### [MODIFY] [pubspec.yaml](file:///C:/Users/User/StudioProjects/prayer_companion/pubspec.yaml)
- Add `record` for audio capturing.
- Add `tflite_flutter` (optional, for future AI detection).

#### [MODIFY] [hive_database.dart](file:///C:/Users/User/StudioProjects/prayer_companion/lib/core/db/hive_database.dart)
- Add keys for Jamat times and overlay preferences.

### Feature: Jamat Management

#### [NEW] [jamat_settings_screen.dart](file:///C:/Users/User/StudioProjects/prayer_companion/lib/features/prayer/presentation/screens/jamat_settings_screen.dart)
- UI for users to input manual Jamat times for all 5 prayers.
- Configuration for "Warning Duration" (e.g., 5, 10, 15 minutes before Jamat).
- Toggle for "Auto-Overlay" and "Listening Mode".

#### [NEW] [jamat_provider.dart](file:///C:/Users/User/StudioProjects/prayer_companion/lib/features/prayer/presentation/providers/jamat_provider.dart)
- Riverpod provider to manage and persist Jamat times.

### Feature: Immersive Salah Overlap & Adhan

#### [MODIFY] [fullscreen_prayer_screen.dart](file:///C:/Users/User/StudioProjects/prayer_companion/lib/features/prayer/presentation/screens/fullscreen_prayer_screen.dart)
- Add **Adhan Audio Playback** logic using `AdhanAudioService`.
- Add a "Dismiss" button to exit the overlay.
- Display "Jamat in X minutes" if triggered by a Jamat warning.

### Feature: Background Listening Service

#### [NEW] [background_listener_service.dart](file:///C:/Users/User/StudioProjects/prayer_companion/lib/core/services/background_listener_service.dart)
- Infrastructure to keep the microphone active in the background.
- Logic to prevent multiple responses for the same prayer time.

### Desktop Integration

#### [MODIFY] [desktop_service.dart](file:///C:/Users/User/StudioProjects/prayer_companion/lib/core/services/desktop_service.dart)
- Improve tray interaction to show/hide the Jamat countdown.

## Verification Plan

### Automated Tests
- Logic tests for Jamat warning triggers (e.g., verify it fires exactly 5 minutes before the set time).

### Manual Verification
- Test manual Jamat time entry.
- Verify the Fullscreen Overlay appears with Adhan audio at the scheduled time.
- Verify the "Dismiss" functionality works to return to normal desktop use.
- Check background microphone activity (indicated by system icons).
