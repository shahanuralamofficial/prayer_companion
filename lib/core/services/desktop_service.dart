import 'dart:io';
import 'package:system_tray/system_tray.dart';
import 'package:window_manager/window_manager.dart';

class DesktopService {
  final SystemTray _systemTray = SystemTray();

  Future<void> initSystemTray() async {
    if (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS) return;

    String iconPath = Platform.isWindows ? 'assets/app_icon.ico' : 'assets/app_icon.png';

    // Verify if icon exists, otherwise it might crash or show nothing
    if (!File(iconPath).existsSync()) {
      // In a real app, you'd handle this or use a default
    }

    await _systemTray.initSystemTray(
      title: "Prayer Companion",
      iconPath: iconPath,
    );

    final Menu menu = Menu();
    await menu.buildFrom([
      MenuItemLabel(label: 'Show App', onClicked: (menuItem) => windowManager.show()),
      MenuItemLabel(label: 'Hide App', onClicked: (menuItem) => windowManager.hide()),
      MenuSeparator(),
      MenuItemLabel(label: 'Quit', onClicked: (menuItem) => exit(0)),
    ]);

    await _systemTray.setContextMenu(menu);

    _systemTray.registerSystemTrayEventHandler((eventName) {
      if (eventName == kSystemTrayEventClick) {
        Platform.isMacOS ? _systemTray.popUpContextMenu() : windowManager.show();
      } else if (eventName == kSystemTrayEventRightClick) {
        _systemTray.popUpContextMenu();
      }
    });
  }

  Future<void> updateTrayTitle(String title) async {
    if (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS) return;
    await _systemTray.setTitle(title);
  }

  Future<void> showFullscreenOverlay() async {
    await windowManager.setFullScreen(true);
    await windowManager.setAlwaysOnTop(true);
    await windowManager.show();
  }
}
