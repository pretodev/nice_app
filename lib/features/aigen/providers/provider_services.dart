import 'package:nice/features/aigen/data/open_router.dart';
import 'package:nice/shared/environment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider_services.g.dart';

@riverpod
OpenRouter openRouter(Ref ref) {
  return OpenRouter(Environment.openRouterApiKey);
}
