import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nice/core/data/firestore/firestore_custom_reference.dart';
import 'package:nice/features/trainning/data/training.dart';

class FirestoreTrainningDocument
    extends FirestoreCustomDocumentReference<Training> {
  FirestoreTrainningDocument() : super('training');

  @override
  Training fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    // TODO: implement fromFirestore
    throw UnimplementedError();
  }

  @override
  Map<String, Object?> toFirestore(Training value, SetOptions? options) {
    // TODO: implement toFirestore
    throw UnimplementedError();
  }
}
