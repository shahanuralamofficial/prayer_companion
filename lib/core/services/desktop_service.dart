import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../routing/app_router.dart';
import '../providers/settings_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/floating_bar_provider.dart';
import '../../features/adhan/data/services/adhan_audio_service.dart';

enum DesktopWindowMode { popup, floating }

class DesktopService extends WindowListener with TrayListener {
  final Ref _ref;
  bool _isInitialized = false;
  bool _isTransitioning = false;
  DesktopWindowMode _currentMode = DesktopWindowMode.popup;

  DesktopService(this._ref);

  Future<String> _getIconPath() async {
    final String assetPath = Platform.isWindows ? 'assets/app_logo.ico' : 'assets/app_logo3232.png';
    final String extension = Platform.isWindows ? '.ico' : '.png';

    try {
      final ByteData data = await rootBundle.load(assetPath);
      final Directory tempDir = await getTemporaryDirectory();
      String iconPath = p.join(tempDir.path, 'app_tray_icon$extension');
      
      final File file = File(iconPath);
      await file.writeAsBytes(data.buffer.asUint8List(), flush: true);
      
      if (Platform.isWindows) {
        iconPath = p.absolute(iconPath).replaceAll('/', '\\');
      }
      return iconPath;
    } catch (e) {
      return Platform.isWindows ? 'assets/app_logo.ico' : 'assets/app_logo3232.png'; 
    }
  }

  Future<void> initSystemTray() async {
    if (_isInitialized) return;
    if (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS) return;

    try {
      final String iconPath = await _getIconPath();
      await Future.delayed(const Duration(milliseconds: 500));

      await trayManager.setIcon(iconPath);
      await trayManager.setToolTip('Prayer Companion');

      final settings = _ref.read(settingsProvider);
      final locale = _ref.read(localeProvider);
      final isBn = locale.languageCode == 'bn';

      List<MenuItem> items = [
        MenuItem(
          key: 'show_app', 
          label: isBn ? 'পুরো তালিকা দেখুন' : 'Show Full List'
        ),
        MenuItem(
          key: 'floating_widget', 
          label: isBn ? 'ফ্লোটিং বার' : 'Floating Bar', 
          checked: settings.showFloatingWidget,
          type: 'checkbox',
        ),
        MenuItem.separator(),
        MenuItem(
          key: 'quit_app', 
          label: isBn ? 'বন্ধ করুন' : 'Quit'
        ),
      ];
      await trayManager.setContextMenu(Menu(items: items));
      
      trayManager.addListener(this);
      windowManager.addListener(this);
      
      _isInitialized = true;

      // Auto-show floating bar if enabled
      if (settings.showFloatingWidget) {
        _currentMode = DesktopWindowMode.floating;
        await switchToFloatingMode();
      }
    } catch (e) {
      debugPrint("Tray init failed: $e");
    }
  }

  @override
  void onTrayIconMouseDown() async {
    if (_isTransitioning) return;

    // Toggle logic: if already open in popup mode, hide it or return to floating.
    bool isVisible = await windowManager.isVisible();
    if (isVisible && _currentMode == DesktopWindowMode.popup) {
      final settings = _ref.read(settingsProvider);
      if (settings.showFloatingWidget) {
        await switchToFloatingMode(center: false);
      } else {
        await windowManager.hide();
      }
    } else {
      await switchToPopupMode();
    }
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) async {
    if (_isTransitioning) return;

    if (menuItem.key == 'show_app') {
      await switchToPopupMode();
    } else if (menuItem.key == 'floating_widget') {
      final newVal = !(menuItem.checked ?? false);
      _ref.read(settingsProvider.notifier).toggleFloatingWidget(newVal);
      
      _isInitialized = false;
      await initSystemTray();
      
      if (newVal) {
        await switchToFloatingMode();
      } else {
        await windowManager.hide();
      }
    } else if (menuItem.key == 'quit_app') {
      exit(0);
    }
  }

  Future<void> switchToFloatingMode({bool center = true}) async {
    debugPrint("Switching to Floating Mode...");
    await _ref.read(adhanAudioServiceProvider).stopAdhan();
    
    // Reset expansion state to prevent overflow when resizing window
    _ref.read(floatingBarExpansionProvider.notifier).state = false;
    
    _isTransitioning = true;
    _currentMode = DesktopWindowMode.floating;
    
    await windowManager.hide();
    _ref.read(appRouterProvider).go('/floating-widget');
    await Future.delayed(const Duration(milliseconds: 100));

    await windowManager.setHasShadow(false);
    await windowManager.setBackgroundColor(Colors.transparent);
    await windowManager.setSkipTaskbar(true); // Always hide from taskbar
    await windowManager.setSize(const Size(350, 80)); 
    await windowManager.setAlwaysOnTop(false); 
    await windowManager.setResizable(false);
    
    if (center) {
      await windowManager.center();
    }
    
    await Future.delayed(const Duration(milliseconds: 200));
    await windowManager.show();
    _isTransitioning = false;
  }

  Future<void> switchToPopupMode() async {
    debugPrint("Switching to Popup Mode...");
    await _ref.read(adhanAudioServiceProvider).stopAdhan();
    _isTransitioning = true;
    _currentMode = DesktopWindowMode.popup;
    
    await windowManager.hide();
    _ref.read(appRouterProvider).go('/tray-popup');
    await Future.delayed(const Duration(milliseconds: 100));

    await windowManager.setHasShadow(true);
    // Increased window height to accommodate the 760px widget
    await windowManager.setSize(const Size(440, 800)); 
    await windowManager.setAlwaysOnTop(false);
    await windowManager.setResizable(true);
    await windowManager.setSkipTaskbar(true); // Always hide from taskbar
    await windowManager.center(); 
    
    await Future.delayed(const Duration(milliseconds: 200));
    await windowManager.show();
    await windowManager.focus();
    _isTransitioning = false;
  }

  Future<void> setWindowSize(Size size) async {
    await windowManager.setSize(size);
  }

  Future<void> setWindowPosition(Offset position) async {
    await windowManager.setPosition(position);
  }

  @override
  void onWindowBlur() async {
    // Persistent: do NOT hide on focus loss.
  }

  Future<void> updateTrayTitle(String title) async {
    if (!_isInitialized) return;
    await trayManager.setToolTip(title);
  }

  void dispose() {
    trayManager.removeListener(this);
    windowManager.removeListener(this);
  }
}

final desktopServiceProvider = Provider((ref) {
  final service = DesktopService(ref);
  ref.onDispose(() => service.dispose());
  return service;
});
