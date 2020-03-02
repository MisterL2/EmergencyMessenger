import 'package:audioplayers/audio_cache.dart';

class SoundManager {
  static AudioCache player = AudioCache(prefix: "sounds/");
  static void initialise() {
    print("Pre-loading audio!");
    player.loadAll(['dank_victory.wav','pling.wav']); //Pre-Load sounds for better performance
  }
}