import 'package:cli_util/cli_logging.dart' as cli;
import 'package:logging/logging.dart';

late final cli.Logger logger;

final cli.Ansi ansi = cli.Ansi(true);

const Level _fatalLevel = Level.SEVERE;
const Level _warnLevel = Level.WARNING;
const Level _infoLevel = Level.INFO;
const Level _debugLevel = Level.ALL;

typedef LogRecordPrinter = String Function(LogRecord);

extension LevelColor on Level {
  String get color => switch (value) {
    < 700 /* Level.CONFIG.value */ => ansi.blue,
    < 800 /* Level.INFO.value */ => ansi.cyan,
    < 900 /* Level.WARNING.value */ => ansi.green,
    < 1000 /* Level.SEVERE.value */ => ansi.yellow,
    _ => ansi.red,
  };
}

String verboseRecordPrinter(LogRecord record) {
  final level = record.level;

  return '${level.color}${level.name}${ansi.noColor}: ${record.message}';
}

String recordPrinter(LogRecord record) {
  final level = record.level;
  final message = record.message;

  return level > _infoLevel
      ? '${level.color}$message${ansi.noColor}'
      : message;
}

cli.Logger setupLogger(String level, {LogRecordPrinter? logRecordPrinter}) {
  final logLevel = switch (level.toLowerCase()) {
    'fatal' => _fatalLevel,
    'warn' => _warnLevel,
    'debug' => _debugLevel,
    _ => _infoLevel,
  };

  final verboseLogger = logLevel == _debugLevel;

  if (verboseLogger) {
    logger = cli.Logger.verbose(ansi: ansi);
    logRecordPrinter ??= verboseRecordPrinter;
  } else {
    logger = cli.Logger.standard(ansi: ansi);
    logRecordPrinter ??= recordPrinter;
  }

  Logger.root
    ..level = logLevel
    ..onRecord.listen(
      verboseLogger
          ? (record) {
              final output = record.level > _infoLevel ? logger.stderr : logger.stdout;

              output(logRecordPrinter!(record));
            }
          : (record) {},
    );

  return logger;
}
