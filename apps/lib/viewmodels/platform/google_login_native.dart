import 'package:google_sign_in/google_sign_in.dart';
import 'google_login_stub.dart';
export 'google_login_stub.dart';

class GoogleLoginHelperNative implements GoogleLoginHelper {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );

  @override
  Future<dynamic> signIn() async => await _googleSignIn.signIn();
  @override
  Future<void> signOut() async => await _googleSignIn.signOut();
}

GoogleLoginHelper getGoogleLoginHelper() => GoogleLoginHelperNative();
