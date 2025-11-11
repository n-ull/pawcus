import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:rollbar_flutter_aio/rollbar.dart' show Rollbar;
import 'package:rollbar_flutter_aio/common/rollbar_common.dart' as rollbar_common;

import 'package:pawcus/core/models/settings.dart';


typedef RollbarLevel = rollbar_common.Level;


final Logger logger = Logger('Pawcus');


const logHandlers = {
  'printer': _printLog,
  'rollbar': _rollbarLog,

};


Future<void> setupLogging(AppConfiguration configuration) async {
  Logger.root.level = configuration.logLevel;
  Logger.root.onRecord.listen(logHandlers[configuration.logHandler] ?? _printLog);
}


String _formatLog(LogRecord record) {
  return '[${record.level.name}] (${record.time}) : ${record.message}';
}


void _printLog(LogRecord record) {
  debugPrint(_formatLog(record));
}


void _rollbarLog(LogRecord record) {
  final messageOrError = record.error ?? _formatLog(record);

  if (!_isRollbarAvailable()) {
    // Log messages when Rollbar is not yet initialized
    debugPrint('Early log: $messageOrError');
    if (record.error != null) debugPrint('Error: ${record.error}');
    if (record.stackTrace != null) debugPrintStack(stackTrace: record.stackTrace);
    return;
  }

  final level = rollbarLevel(record.level);
  if (level == null) return;
  Rollbar.log(messageOrError, level: level, stackTrace: record.stackTrace ?? StackTrace.empty);
}


bool _isRollbarAvailable() {
  try {
    Rollbar.current;
    return true;
  } catch (_) {
    return false;
  }
}


RollbarLevel? rollbarLevel(Level level) {
  return switch (level) {
    Level.OFF => null,
    Level.SHOUT => RollbarLevel.critical,
    Level.SEVERE => RollbarLevel.error,
    Level.WARNING => RollbarLevel.warning,
    Level.INFO || Level.CONFIG => RollbarLevel.info,
    _ => RollbarLevel.debug,
  };
}
