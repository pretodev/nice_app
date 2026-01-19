import 'package:cloud_firestore/cloud_firestore.dart';

abstract class _FirestoreCustomReference<T> {
  final String _collectionName;

  _FirestoreCustomReference(this._collectionName);

  T fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  );

  Map<String, Object?> toFirestore(T value, SetOptions? options);
}

abstract class FirestoreCustomDocumentReference<T>
    extends _FirestoreCustomReference<T> {
  FirestoreCustomDocumentReference(super._collectionName);

  DocumentReference<T> ref(String id) => FirebaseFirestore.instance
      .collection(_collectionName)
      .doc(id)
      .withConverter(fromFirestore: fromFirestore, toFirestore: toFirestore);
}

abstract class FirestoreCustomCollectionReference<T>
    extends _FirestoreCustomReference<T> {
  FirestoreCustomCollectionReference(super._collectionName);

  CollectionReference<T> get ref => FirebaseFirestore.instance
      .collection(_collectionName)
      .withConverter(fromFirestore: fromFirestore, toFirestore: toFirestore);

  Future<void> softDelete(String id) async {
    return FirebaseFirestore.instance.collection(_collectionName).doc(id).set({
      'deletedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
