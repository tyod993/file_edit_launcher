class LauncherResult {
  static const fileNotFound = 1;
  static const permissionDenied = 2;
  static const filePathNull = 4;
  static const unknown = 8;

  final bool successful;

  final int? error;

  final StackTrace? stackTrace;

  LauncherResult(this.successful, this.error, this.stackTrace);
}
