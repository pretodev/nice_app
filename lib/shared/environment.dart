abstract class Environment {
  Environment._();

  static const openRouterApiKey = String.fromEnvironment('OPEN_ROUTER_API_KEY');

  /// URL utilizada como destino do link enviado via Firebase Email Link.
  /// Deve estar listado em "Authorized domains" do projeto Firebase.
  static const emailLinkContinueUrl = String.fromEnvironment(
    'EMAIL_LINK_CONTINUE_URL',
    defaultValue: 'https://valney-fitness.firebaseapp.com/finishSignIn',
  );

  static const emailLinkAndroidPackageName = String.fromEnvironment(
    'EMAIL_LINK_ANDROID_PACKAGE',
    defaultValue: 'com.example.nice',
  );

  static const emailLinkIosBundleId = String.fromEnvironment(
    'EMAIL_LINK_IOS_BUNDLE_ID',
    defaultValue: 'com.example.nice',
  );
}
