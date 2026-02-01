abstract class Environment {
  Environment._();

  static const openRouterApiKey = String.fromEnvironment('OPEN_ROUTER_API_KEY');
  static const pocketbaseUrl = String.fromEnvironment(
    'POCKETBASE_URL',
    defaultValue: 'https://api.odulab.com.br/',
  );
}
