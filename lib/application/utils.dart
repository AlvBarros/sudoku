import 'package:sudokats/application/logger.dart';
import 'package:vibration/vibration.dart';

Future<void> vibrationFeedback() async {
  final hasVibrator = await Vibration.hasVibrator();
  if (!hasVibrator) {
    logger.w('Device does not support vibration');
    return;
  }
  Vibration.vibrate(duration: 25, amplitude: 128);
}