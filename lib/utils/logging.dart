import 'package:logger/logger.dart';

final _logger = Logger(filter: DevelopmentFilter(), printer: PrettyPrinter(printEmojis: true));

void printLog({dynamic message, dynamic error, StackTrace? stackTrace}) {
  if (error == null) {
    _logger.d(message);
  } else {
    _logger.e(message);
  }
}
