import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../firestore_document.dart';

extension DocumentSnapshotExtensions on DocumentSnapshot {
  T convert<T>(Serializers serializers, Serializer<T> serializer) {
    if (exists) {
      data['id'] = documentID;
      return serializers.deserializeWith(serializer, data);
    }
    return null;
  }
}

extension FirestoreDocumentExtensions on FirestoreDocument {
  Map<String, dynamic> toData(Serializers serializers, Serializer serializer) =>
      serializers.serializeWith(serializer, this);
}
