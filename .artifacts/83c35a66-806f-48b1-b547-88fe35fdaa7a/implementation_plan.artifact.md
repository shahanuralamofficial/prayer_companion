# Implementation Plan - Settings Screen Design Refresh

This plan updates the Settings screen to perfectly match the "Liquid Glass" design language of the Tray Popup, ensuring global consistency across the app.

## User Review Required

> [!IMPORTANT]
> **Layout Fix**: I will resolve the overflow issue in the "Method" dropdown by allowing more flexible horizontal space for localized text.

> [!NOTE]
> **Global Theme**: All settings sections will now use the same high-blur frosted teal background seen in the main tray popup.

## Proposed Changes

### 1. UI Refinement (Settings Screen)

#### [MODIFY] [settings_screen.dart](file:///C:/Users/User/StudioProjects/prayer_companion/lib/features/settings/presentation/screens/settings_screen.dart)
- Update the main `body` to use the same background logic as the `TrayPopup`.
- Wrap the main settings content in a `LiquidGlassContainer` or ensure individual section containers use the exact `glassBlur` and `glassOpacity` values.
- **Dropdown Fix**: Update `_buildDropdownTile` to use a `Flexible` or `Expanded` title to prevent the "Method" text from overflowing when translated.
- Apply consistent spacing and font weights to match the "Liquid Glass" aesthetic.

### 2. Design Alignment

- Ensure all `Scaffold` backgrounds in the settings area are transparent or use the frosted milky teal gradient.

## Verification Plan

### Manual Verification
1.  **Visual Match**: Verify that the Settings screen looks identical in style (color, blur, opacity) to the Tray Popup.
2.  **Overflow Check**: Confirm that the "Method" (পদ্ধতি) text is fully visible in both Bengali and English.
3.  **Responsiveness**: Verify that the settings list scrolls smoothly behind the frosted glass layer.
