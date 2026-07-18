import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'platform/web_helper.dart';

class SoundService {
  static AudioPlayer? _mobilePlayer;

  static Future<void> playPop() async {
    await _play('assets/sounds/pop.mp3', 0.5);
  }

  static Future<void> playClick() async {
    await _play('assets/sounds/click.mp3', 0.3);
  }

  static Future<void> playSuccess() async {
    await _play('assets/sounds/success.mp3', 0.6);
  }

  static Future<void> playSOS() async {
    await _play('assets/sounds/sos.mp3', 1.0);
  }

  static Future<void> _play(String assetPath, double volume) async {
    if (kIsWeb) {
      // Browsers block audio/vibration unless a user gesture occurred.
      // WebHelper handles the audio catch block.
      WebHelper.playAudio(assetPath, volume);
      return;
    }

    try {
      _mobilePlayer ??= AudioPlayer();
      final cleanPath = assetPath.replaceFirst('assets/', '');
      await _mobilePlayer!.stop();
      await _mobilePlayer!.setVolume(volume);
      await _mobilePlayer!.play(AssetSource(cleanPath));
    } catch (e) {
      debugPrint('Sound Service Error ($assetPath): $e');
    }
  }
}
