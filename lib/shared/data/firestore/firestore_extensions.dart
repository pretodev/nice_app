import 'package:cloud_firestore/cloud_firestore.dart';

extension QueryResultsExtension<T> on Stream<QuerySnapshot<T>> {
  Stream<List<T>> get data {
    return map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}

extension DocumentSnapshotExtension on DocumentSnapshot {
  Map<String, dynamic> get map => data() as Map<String, dynamic>;
}

extension DateTimeExtension on DateTime {
  Timestamp toTimestamp() {
    return Timestamp.fromDate(this);
  }
}
