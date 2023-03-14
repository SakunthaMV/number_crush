import 'package:audioplayers/audioplayers.dart';
import 'package:number_crush/Services/databaseFunctions.dart';

class AudioController {
  final DatabaseFunctions db = DatabaseFunctions();
  Future<void> play(String path) async {
    final bool enabled = await db.getSettingStatus('sound');
    if (enabled) {
      final AudioPlayer player = AudioPlayer();
      await player.play(AssetSource(path));
    }
  }
}
