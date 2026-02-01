import 'package:pocketbase/pocketbase.dart';

abstract class PocketBaseTableReference<T> {
  PocketBaseTableReference(this.collectionName, this.pb);

  final String collectionName;
  final PocketBase pb;

  T fromRecord(RecordModel record);

  Map<String, dynamic> toData(T entity);

  Stream<T?> streamById(String id) {
    return Stream.periodic(const Duration(seconds: 1), (_) async {
      try {
        final record = await pb.collection(collectionName).getOne(id);
        return fromRecord(record);
      } catch (e) {
        if (e is ClientException && e.statusCode == 404) {
          return null;
        }
        rethrow;
      }
    }).asyncExpand((future) => Stream.fromFuture(future));
  }

  Future<void> upsert(T entity) async {
    final data = toData(entity);
    final id = data['id'] as String?;

    if (id == null || id.isEmpty) {
      // Create new record
      await pb.collection(collectionName).create(body: data);
    } else {
      try {
        // Try to update existing record
        await pb.collection(collectionName).update(id, body: data);
      } on ClientException catch (e) {
        // If not found, create it
        if (e.statusCode == 404) {
          await pb.collection(collectionName).create(body: data);
        } else {
          rethrow;
        }
      }
    }
  }

  Future<void> delete(String id) async {
    await pb.collection(collectionName).delete(id);
  }
}
