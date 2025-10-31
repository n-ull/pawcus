import 'package:logging/logging.dart';
import 'package:rollbar_flutter_aio/rollbar.dart' show Rollbar;
import 'package:rollbar_flutter_aio/common/rollbar_common.dart' as rollbar_common;

import 'package:pawcus/core/models/settings.dart';


typedef RollbarLevel = rollbar_common.Level;


final Logger logger = Logger('Qoxaria');


const logHandlers = {
  'printer': _printLog,
  'rollbar': _rollbarLog,

};


Future<void> setupLogging(AppConfiguration configuration) async {
  // TODO: Make this configurable through the env or something!
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen(logHandlers[configuration.logHandler]);
}


String _formatLog(LogRecord record) {
  return '[${record.level.name}] (${record.time}) : ${record.message}';
}


void _printLog(LogRecord record) {
  // ignore: avoid_print
  print(_formatLog(record));
}


void _rollbarLog(LogRecord record) {
  final level = rollbarLevel(record.level);
  if (level == null) return;
  Rollbar.log(_formatLog(record), level: level);
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
