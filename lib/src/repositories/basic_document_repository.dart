import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../firestore_bloc.dart';
import '../firestore_document.dart';

class BasicDocumentRepository<T extends FirestoreDocument>
    extends FirestoreDocumentRepository<T> {
  final CollectionReference parentCollectionRef;
  final String documentId;
  final Serializer<T> _documentSerializer;

  BasicDocumentRepository(
      this.parentCollectionRef, this.documentId, Serializer<T> serializer)
      : _documentSerializer = serializer;

  @override
  DocumentReference get documentReference =>
      parentCollectionRef.document(documentId);

  @override
  Serializer<T> get serializer => _documentSerializer;
}
