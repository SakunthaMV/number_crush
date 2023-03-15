import 'package:vibration/vibration.dart';

import '../Services/databaseFunctions.dart';

class VibrationController {
  final DatabaseFunctions db = DatabaseFunctions();
  void vibtrate({int? duration, int? amplitude}) async {
    final bool enabled = await db.getSettingStatus('vibration');
    if (enabled) {
      Vibration.vibrate(duration: duration ?? 200, amplitude: amplitude ?? -1);
    }
  }
}
