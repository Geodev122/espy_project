import 'google_login_stub.dart';
export 'google_login_stub.dart';

class GoogleLoginHelperWeb implements GoogleLoginHelper {
  @override
  Future<dynamic> signIn() async => null;
  @override
  Future<void> signOut() async {}
}

GoogleLoginHelper getGoogleLoginHelper() => GoogleLoginHelperWeb();
