class WebHelper {
  static void openPopUp(String url, String name, int width, int height) {}
  static void playAudio(String src, double volume) {}
  static double get screenWidth => 0.0;
  static double get screenHeight => 0.0;
  static String get currentUrl => '';
}

class GoogleSignIn {
  GoogleSignIn({List<String>? scopes});
  Future<dynamic> signIn() async => null;
  Future<void> signOut() async {}
}
