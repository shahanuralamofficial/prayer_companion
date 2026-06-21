# Implementation Plan - Universal Luxury & Liquid Glass Extension

Apply the premium "Liquid Glass" design language across all screens of the application to ensure a consistent, high-end user experience.

## User Review Required

> [!IMPORTANT]
> **Tray Popup Transformation:** I will redesign the Desktop Tray Popup to be a pixel-perfect match for the reference screenshot you provided, while enhancing it with the "Liquid Glass" effects and Luxury Gold accents.

## Proposed Changes

### 1. Feature Screen Overhauls (Universal Liquid Glass)

#### [MODIFY] [Settings Screen](file:///C:/Users/User/StudioProjects/prayer_companion/lib/features/settings/presentation/screens/settings_screen.dart)
- Replace basic tiles with `LiquidGlassContainer` items.
- Use **Playfair Display** for section headers and **Luxury Gold** for icons.
- Add entry animations for each settings group.

#### [MODIFY] [Jamat Settings](file:///C:/Users/User/StudioProjects/prayer_companion/lib/features/prayer/presentation/screens/jamat_settings_screen.dart)
- Apply the luxury design to manual time pickers.
- Use golden switches and refined typography for duration selectors.

#### [MODIFY] [Quran Home](file:///C:/Users/User/StudioProjects/prayer_companion/lib/features/quran/presentation/screens/quran_home_screen.dart)
- Redesign Surah list items as "Premium Glass Cards".
- Add a golden "Ayah Count" badge for each Surah.
- Use a luxurious background consistent with the Dashboard.

#### [MODIFY] [Qibla Finder](file:///C:/Users/User/StudioProjects/prayer_companion/lib/features/qibla/presentation/screens/qibla_screen.dart)
- Overhaul the compass UI with a "Liquid Glass" dial.
- Use a 3D-effect golden needle.
- Add real-time distance cards using `LiquidGlassContainer`.

#### [MODIFY] [Digital Tasbih](file:///C:/Users/User/StudioProjects/prayer_companion/lib/features/tasbih/presentation/screens/tasbih_screen.dart)
- Create a large, immersive circular "Liquid Glass" counter button.
- Add a golden aura/glow that pulses on tap.
- Use **Playfair Display** for the large digits.

#### [MODIFY] [Islamic Calendar](file:///C:/Users/User/StudioProjects/prayer_companion/lib/features/calendar/presentation/screens/calendar_screen.dart)
- Design a prestigious "Date Card" using the luxury theme.
- Transform event items into glassmorphic timeline entries.

### 2. Desktop & System Tray Polish

#### [MODIFY] [Tray Popup](file:///C:/Users/User/StudioProjects/prayer_companion/lib/features/desktop/presentation/widgets/tray_popup.dart)
- **Visual Match:** Align the layout exactly with the provided screenshot (centered current prayer, countdown below, list of daily times).
- **Luxury Touch:** Use a high-sigma backdrop blur and golden progress indicators for the active prayer.

#### [MODIFY] [Fullscreen Overlay](file:///C:/Users/User/StudioProjects/prayer_companion/lib/features/prayer/presentation/screens/fullscreen_prayer_screen.dart)
- Refine the central message box with `LiquidGlassContainer`.
- Enhance the mosque icon with a golden glow and material depth.

## Verification Plan

### Manual Verification
- **Visual Consistency Audit:** Navigate through every screen to ensure the "Liquid Glass" and "Luxury Gold" theme is applied without exception.
- **Tray Interaction:** Verify that the Tray Popup looks exactly like the reference on Windows/macOS.
- **Animation Check:** Ensure all screen transitions and widget entries are fluid and prestigious.
