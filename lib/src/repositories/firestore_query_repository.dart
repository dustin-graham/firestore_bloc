import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../firestore_bloc.dart';
import '../extensions/firestore_extensions.dart';
import '../firestore_document.dart';

abstract class FirestoreQueryRepository<T extends FirestoreDocument> {
  /// The query used to list the items in the collection
  Query get query;

  Serializer get serializer;

  T deserializeSnapshot(DocumentSnapshot snapshot) {
    return snapshot.convert(FirestoreBloc.instance.serializers, serializer);
  }

  bool documentIsValid(Map<String, dynamic> documentData) {
    return true;
  }

  Stream<List<T>> streamQuery(Query query) {
    final mapSnapshots = (QuerySnapshot snapshot) {
      return snapshot.documents
          .where((documentSnapshot) =>
              documentSnapshot.data != null &&
              documentIsValid(documentSnapshot.data))
          .map<T>(deserializeSnapshot)
          .toList();
    };
    return query.snapshots().handleError((e) {
      print(e);
    }).map(mapSnapshots);
  }

  Stream<List<T>> list() {
    return streamQuery(query);
  }
}
