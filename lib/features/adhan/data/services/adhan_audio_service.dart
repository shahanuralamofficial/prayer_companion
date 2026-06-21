import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

class AdhanAudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playAdhan(String adhanPath) async {
    try {
      await _audioPlayer.play(AssetSource(adhanPath));
    } catch (e) {
      debugPrint("Adhan playback failed (file might be missing): $e");
    }
  }

  Future<void> stopAdhan() async {
    await _audioPlayer.stop();
  }

  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume);
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}

final adhanAudioServiceProvider = Provider((ref) {
  final service = AdhanAudioService();
  ref.onDispose(() => service.dispose());
  return service;
});
