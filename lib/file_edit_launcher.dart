import 'dart:io';
import 'dart:async';

import 'package:file_edit_launcher/launcher_response.dart';
import 'package:flutter/services.dart';

class FileEditLauncher {
  static const MethodChannel _channel = MethodChannel('file_edit_launcher');

  ///
  ///TODO document what this does on IOS
  ///Launches an app chooser on Android for the user to pick and app
  ///to view or edit the desired File. Make sure that the File is readable
  ///and editable. This finishes when the user has finished editing or viewing
  ///the file.
  ///
  ///When opening with PDF Viewer Pro this returns too early because of how
  ///they have devolped thier app
  ///
  static Future<LauncherResult> launchFileEditor(File file) async {
    int? er;
    StackTrace? stack;

    await _channel.invokeMethod(
        'launch_file_editor', {'file_path': file.absolute.path}).onError((error,
            stackTrace) =>
        {er = parseError(error as String), stack = stackTrace});
    return er != null
        ? LauncherResult(false, er, stack)
        : LauncherResult(true, null, stack);
  }

  static int parseError(String errorCode) {
    switch (errorCode) {
      case "Permission Denied":
        {
          return LauncherResult.permissionDenied;
        }
      case "File Missing":
        {
          return LauncherResult.fileNotFound;
        }
      case "File Path Null":
        {
          return LauncherResult.filePathNull;
        }
    }
    return LauncherResult.unknown;
  }
}
