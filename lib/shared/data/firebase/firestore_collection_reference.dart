import 'package:cloud_firestore/cloud_firestore.dart';

/// Base para mapeamentos de coleções no Firestore.
abstract class FirestoreCollectionReference<T> {
  FirestoreCollectionReference(this.collectionName, this.firestore);

  final String collectionName;
  final FirebaseFirestore firestore;

  CollectionReference<Map<String, dynamic>> get collection =>
      firestore.collection(collectionName);

  T fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot);

  Map<String, dynamic> toData(T entity);

  /// Stream do documento. Emite `null` quando o documento não existe.
  Stream<T?> streamById(String id) {
    return collection
        .doc(id)
        .snapshots()
        .map((snapshot) => snapshot.exists ? fromSnapshot(snapshot) : null);
  }

  Future<void> upsert(T entity) async {
    final data = toData(entity);
    final id = data['id'] as String?;

    if (id == null || id.isEmpty) {
      await collection.add(data);
      return;
    }

    await collection.doc(id).set(data, SetOptions(merge: true));
  }

  Future<void> delete(String id) async {
    await collection.doc(id).delete();
  }
}
