import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../firestore_bloc.dart';

class BasicDocumentRepository<T extends FirestoreDocument>
    extends FirestoreDocumentRepository<T> {
//  final CollectionReference parentCollectionRef;
//  final String documentId;
  final Serializer<T> _documentSerializer;
  final String referencePath;

  BasicDocumentRepository(this.referencePath, Serializer<T> serializer)
      : _documentSerializer = serializer;

  factory BasicDocumentRepository.fromPath(
      CollectionReference parentCollectionRef,
      String documentId,
      Serializer<T> serializer) {
    return BasicDocumentRepository(
        parentCollectionRef.document(documentId).path, serializer);
  }

  @override
  DocumentReference get documentReference =>
      Firestore.instance.document(referencePath);

  @override
  Serializer<T> get serializer => _documentSerializer;
}
