import 'package:vibration/vibration.dart';

import '../Services/database_functions.dart';

class VibrationController {
  final DatabaseFunctions db = DatabaseFunctions();
  void vibrate({int? duration, int? amplitude}) async {
    final bool enabled = await db.getSettingStatus('vibration');
    if (enabled) {
      Vibration.vibrate(duration: duration ?? 200, amplitude: amplitude ?? -1);
    }
  }
}
