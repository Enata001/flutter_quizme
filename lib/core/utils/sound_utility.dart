import 'package:audioplayers/audioplayers.dart';

class QuizSoundUtility {
  static final AudioPlayer _audioPlayer = AudioPlayer();

  static Future<void> playSound(String sound) async {
    await _audioPlayer.play(AssetSource(sound));
  }
static Future<void> stopSound()async{
    await _audioPlayer.stop();
}
}