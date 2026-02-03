import 'package:nice/shared/environment.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shared_data_provider.g.dart';

@riverpod
PocketBase pocketbaseClient(Ref ref) {
  return PocketBase(Environment.pocketbaseUrl);
}
