# Prayer Companion - Liquid Glass Edition

A premium, desktop-only prayer time application for Windows, macOS, and Linux. This app features a native-inspired "Liquid Glass" design with high-blur teal surfaces, real-time countdowns, and automated system integration.

![Prayer Companion UI](https://github.com/tareq1988/prayer-times-macos/raw/main/Screenshots/main.png) 
*(Design based on tareq1988/prayer-times-macos)*

## ✨ Features

- **🚀 Desktop First**: Optimized exclusively for Windows, Linux, and macOS. Lives in your system tray.
- **🧊 Liquid Glass UI**: Premium frosted-glass aesthetic with high-blur teal backgrounds and smooth animations.
- **🕒 Full Prayer Suite**:
  - Daily 5 prayers + **Tahajjud** support.
  - Live countdown timers for the next prayer.
  - 10+ Calculation methods (Diyanet, MWL, ISNA, etc.).
  - Standard & Hanafi Asr Madhab selection.
- **🔔 Smart Notifications**:
  - Automated Adhan (Azan) playback.
  - Early reminders (5, 10, 15 min before).
  - Iqamah alerts.
- **🌍 Dynamic Geo-Logic**:
  - Automatic city & country detection (Geocoding).
  - Standardized Timezone ID (e.g., Asia/Dhaka).
  - Precise coordinate-based astronomical calculations.
- **⚙️ Power Features**:
  - **Launch at Login**: Automatically starts when your PC boots.
  - **Siri-Style Overlay**: Immersive fullscreen alerts for prayer times.
  - **Multi-language**: Full support for English and বাংলা (Bengali).

## 🛠️ Setup & Installation

### Development
1. Ensure you have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
2. Clone the repository.
3. Run `flutter pub get`.
4. Run the app:
   ```bash
   flutter run -d windows  # For Windows
   flutter run -d macos    # For macOS
   ```

### Build
To create a production executable:
```bash
flutter build windows
```

## 📜 Localization
- **English**: Default locale.
- **Bengali (বাংলা)**: 100% localized settings and labels.

## 🤝 Acknowledgments
Design and tray experience inspired by [tareq1988/prayer-times-macos](https://github.com/tareq1988/prayer-times-macos).

---
*Developed with ❤️ for the Ummah.*
