import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdhanAudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playAdhan(String adhanPath) async {
    await _audioPlayer.play(AssetSource(adhanPath));
  }

  Future<void> stopAdhan() async {
    await _audioPlayer.stop();
  }

  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume);
  }
}

final adhanAudioServiceProvider = Provider((ref) => AdhanAudioService());
