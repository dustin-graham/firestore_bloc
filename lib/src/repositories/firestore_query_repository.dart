import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../firestore_bloc.dart';
import '../extensions/firestore_extensions.dart';
import 'basic_document_repository.dart';
import 'firestore_document_repository.dart';

abstract class FirestoreQueryRepository<T extends FirestoreDocument> {

  Serializer<T> get serializer;

  T deserializeSnapshot(DocumentSnapshot snapshot) {
    return snapshot.convert(serializer);
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
    return query.snapshots().map(mapSnapshots);
  }

  FirestoreDocumentRepository getDocumentRepository(String referencePath) {
    return BasicDocumentRepository(referencePath, serializer);
  }
}
