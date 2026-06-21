# Implementation Plan - Bug Fixes & Design Refinement

This plan addresses a comprehensive list of critical bugs, functional issues, and design inconsistencies identified in the project.

## User Review Required

> [!IMPORTANT]
> **Windows Tray Fix**: I am switching to `.ico` for Windows and ensuring the window is ready before initializing the tray. This should permanently resolve the missing icon issue.

> [!WARNING]
> **Adhan Audio**: The `makkah.mp3` file is missing. I will add a `try-catch` to prevent crashes during playback and ensure the app handles missing assets gracefully.

## Proposed Changes

### 1. Critical Tray Fixes

#### [MODIFY] [desktop_service.dart](file:///C:/Users/User/StudioProjects/prayer_companion/lib/core/services/desktop_service.dart)
- Update `_getIconPath()` to use `assets/app_icon.ico` on Windows and `assets/app_logo3232.png` on other platforms.
- Ensure the absolute path for `.ico` is passed correctly to `tray_manager`.

#### [MODIFY] [main.dart](file:///C:/Users/User/StudioProjects/prayer_companion/lib/main.dart)
- **Await `waitUntilReadyToShow`**: Ensure the app waits for the window to be ready before calling `hide()` or other window operations.

#### [MODIFY] [pubspec.yaml](file:///C:/Users/User/StudioProjects/prayer_companion/pubspec.yaml)
- Add `assets/app_icon.ico` to the assets list.

### 2. Functional Bug Fixes

#### [MODIFY] [background_listener_service.dart](file:///C:/Users/User/StudioProjects/prayer_companion/lib/core/services/background_listener_service.dart)
- **Implement `_triggerOverlay`**: Add logic to show the window, focus it, and navigate to `/fullscreen-prayer`.
- **Deduplication Fix**: Change the deduplication key to `"${prayer}_jamat_${DateFormat('yyyy-MM-dd').format(now)}"` to prevent repeated alerts within the same minute.

#### [MODIFY] [app_router.dart](file:///C:/Users/User/StudioProjects/prayer_companion/lib/core/routing/app_router.dart)
- Add the `/fullscreen-prayer` route.

#### [MODIFY] [settings_screen.dart](file:///C:/Users/User/StudioProjects/prayer_companion/lib/features/settings/presentation/screens/settings_screen.dart)
- Implement functional toggles for "Early Reminder", "Iqamah Alerts", and "Launch at Login" using Hive and `launch_at_startup`.
- Replace `Navigator.pop(context)` with `context.pop()`.

#### [MODIFY] [theme_provider.dart](file:///C:/Users/User/StudioProjects/prayer_companion/lib/core/providers/theme_provider.dart)
- Remove redundant `_loadTheme()` call in the constructor.

#### [MODIFY] [tray_provider.dart](file:///C:/Users/User/StudioProjects/prayer_companion/lib/core/providers/tray_provider.dart)
- Add `ref.onDispose(() => timer.cancel())` to prevent memory leaks.

### 3. Design & Localization Refinement

#### [MODIFY] [app_theme.dart](file:///C:/Users/User/StudioProjects/prayer_companion/lib/core/theme/app_theme.dart)
- Reduce `glassBlur` to `40.0` for better performance.

#### [MODIFY] [tray_popup.dart](file:///C:/Users/User/StudioProjects/prayer_companion/lib/features/desktop/presentation/widgets/tray_popup.dart)
- **Dynamic Icons**: Use `_getIconForPrayer` in the Hero section.
- **Contrast**: Fix duration tag text color and divider colors for dark mode.
- **Localization**: Localize "in $countdown".

#### [MODIFY] [fullscreen_prayer_screen.dart](file:///C:/Users/User/StudioProjects/prayer_companion/lib/features/prayer/presentation/screens/fullscreen_prayer_screen.dart)
- Replace hardcoded "7:03" with real-time clock.
- Localize "DISMISS" and "It's time for...".
- Add `try-catch` around Adhan playback.

## Verification Plan

### Automated Verification
- Run `flutter analyze` to ensure no syntax errors.

### Manual Verification
1. **Tray Icon**: Confirm it appears immediately on Windows.
2. **Alert Trigger**: Manually set a Jamat time 1 minute ahead and verify the fullscreen overlay appears.
3. **Settings**: Verify that toggling settings saves the state across app restarts.
4. **Dark Mode**: Verify that dividers and text remain visible.
