import 'dart:js_interop';
import 'package:web/web.dart' as web;

class WebHelper {
  static void openPopUp(String url, String name, int width, int height) {
    final int left = (web.window.screen.width - width) ~/ 2;
    final int top = (web.window.screen.height - height) ~/ 2;

    web.window.open(
      url,
      name,
      'width=$width,height=$height,left=$left,top=$top,scrollbars=yes,resizable=yes'
    );
  }

  static void playAudio(String src, double volume) {
    try {
      final audio = web.document.createElement('audio') as web.HTMLAudioElement;
      final cleanPath = src.replaceFirst('assets/', '');
      
      // Fixed: Flutter Web serves assets from /assets/
      audio.src = 'assets/$cleanPath';
      audio.volume = volume;
      audio.crossOrigin = "anonymous";
      audio.preload = "auto";

      audio.play().toDart.catchError((Object e) {
        if (audio.src.contains('assets/assets/')) {
           audio.src = 'assets/$cleanPath';
           audio.play().toDart.catchError((Object e) => null);
        }
        return null;
      });
    } catch (e) {
      // Ignore
    }
  }

  static double get screenWidth => web.window.screen.width.toDouble();
  static double get screenHeight => web.window.screen.height.toDouble();
  static String get currentUrl => web.window.location.href;
}
