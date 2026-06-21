import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class DesktopService with TrayListener {
  bool _isInitialized = false;

  Future<String> _getIconPath() async {
    // Windows expects .ico for native tray, others can use PNG
    final String assetPath = Platform.isWindows ? 'assets/app_icon.ico' : 'assets/app_logo3232.png';
    final String extension = Platform.isWindows ? '.ico' : '.png';

    try {
      final ByteData data = await rootBundle.load(assetPath);
      final Directory tempDir = await getTemporaryDirectory();
      
      // Use a fixed simple name for the tray icon file
      String iconPath = p.join(tempDir.path, 'app_tray_icon$extension');
      
      final File file = File(iconPath);
      await file.writeAsBytes(data.buffer.asUint8List(), flush: true);
      
      if (Platform.isWindows) {
        iconPath = p.absolute(iconPath).replaceAll('/', '\\');
      }
      
      debugPrint("Robust Tray icon prepared at: $iconPath");
      return iconPath;
    } catch (e) {
      debugPrint("Critical: Failed to prepare tray icon: $e");
      return 'assets/app_logo3232.png'; 
    }
  }

  Future<void> initSystemTray() async {
    if (_isInitialized) return;
    if (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS) return;

    debugPrint("Initializing TrayManager (Robust Mode)...");

    try {
      final String iconPath = await _getIconPath();
      
      // Delay to allow OS window stack to settle
      await Future.delayed(const Duration(milliseconds: 500));

      await trayManager.setIcon(iconPath);
      await trayManager.setToolTip('Prayer Companion');

      List<MenuItem> items = [
        MenuItem(
          key: 'show_app',
          label: 'Show App',
        ),
        MenuItem(
          key: 'hide_app',
          label: 'Hide App',
        ),
        MenuItem.separator(),
        MenuItem(
          key: 'quit_app',
          label: 'Quit',
        ),
      ];
      await trayManager.setContextMenu(Menu(items: items));
      
      trayManager.addListener(this);
      
      _isInitialized = true;
      debugPrint("TrayManager initialized successfully in robust mode");
    } catch (e) {
      debugPrint("TrayManager initialization failed: $e");
    }
  }

  @override
  void onTrayIconMouseDown() async {
    bool isVisible = await windowManager.isVisible();
    if (isVisible) {
      await windowManager.hide();
    } else {
      await windowManager.show();
      await windowManager.focus();
    }
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    if (menuItem.key == 'show_app') {
      windowManager.show();
    } else if (menuItem.key == 'hide_app') {
      windowManager.hide();
    } else if (menuItem.key == 'quit_app') {
      exit(0);
    }
  }

  Future<void> updateTrayTitle(String title) async {
    if (!_isInitialized) return;
    if (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS) return;
    try {
      await trayManager.setToolTip(title);
    } catch (e) {
      debugPrint("Failed to update tray tooltip: $e");
    }
  }

  Future<void> showFullscreenOverlay() async {
    await windowManager.setFullScreen(true);
    await windowManager.setAlwaysOnTop(true);
    await windowManager.show();
  }
}

final desktopServiceProvider = Provider((ref) => DesktopService());
