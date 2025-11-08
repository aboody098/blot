import 'package:fire_safety_console/core/env.dart';

/// Simple logger utility
class Logger {
  static void info(String message, {String? tag}) {
    _log('INFO', message, tag);
  }

  static void debug(String message, {String? tag}) {
    if (Env.isDevelopment) {
      _log('DEBUG', message, tag);
    }
  }

  static void warning(String message, {String? tag}) {
    _log('WARN', message, tag);
  }

  static void error(String message, {String? tag, dynamic exception}) {
    _log('ERROR', message, tag);
    if (exception != null) {
      _log('ERROR', 'Exception: $exception', tag);
    }
  }

  static void _log(String level, String message, String? tag) {
    final timestamp = DateTime.now().toIso8601String();
    final tagStr = tag != null ? '[$tag]' : '';
    print('[$timestamp] [$level] $tagStr $message');
  }
}
