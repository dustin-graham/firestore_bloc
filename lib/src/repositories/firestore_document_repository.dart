import 'package:built_value/serializer.dart' as firestore_document_repository;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../firestore_bloc.dart';
import '../extensions/firestore_extensions.dart';

abstract class FirestoreDocumentRepository<T extends FirestoreDocument> {
  DocumentReference get documentReference;

  String get documentId => documentReference.documentID;

  firestore_document_repository.Serializer<T> get serializer;

  T deserializeSnapshot(DocumentSnapshot snapshot) {
    return snapshot.convert(serializer);
  }

  /// some repos may have things that need to get cleaned up once they are no
  /// longer in use
  Future<void> close() {
    return null;
  }

  Stream<T> stream() {
    return documentReference.snapshots().map(deserializeSnapshot);
  }

  Future<T> get() async {
    return deserializeSnapshot((await documentReference.get()));
  }

  Future<bool> exists() async {
    var snapshot = await documentReference.get();
    return snapshot.exists;
  }

  Future<void> update(T document) async {
    await documentReference.setData(
        FirestoreBloc.instance.serializers.serializeWith(serializer, document));
  }

  Future<void> delete() {
    return documentReference.delete();
  }

  Future<T> current({Source source = Source.serverAndCache}) async {
    final snapshot = await documentReference.get(source: source);
    return deserializeSnapshot(snapshot);
  }
}
