import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 2, // Number of method calls to display
    errorMethodCount: 8, // Number of method calls to display for errors
    lineLength: 120, // Width of the output
    colors: true, // Enable colors
    printEmojis: true, // Enable emojis
    dateTimeFormat: (time) => '[${time.hour}:${time.minute}:${time.second}]',
  ),
);
