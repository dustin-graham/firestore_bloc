import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_bloc/firestore_bloc.dart';

import '../firestore_document.dart';

extension DocumentSnapshotExtensions on DocumentSnapshot {
  T convert<T>(Serializer<T> serializer) {
    if (exists) {
      data['id'] = documentID;
      data['referencePath'] = this.reference.path;
      return FirestoreBloc.instance.serializers
          .deserializeWith(serializer, data);
    }
    return null;
  }
}

extension FirestoreDocumentExtensions on FirestoreDocument {
  Map<String, dynamic> toData(Serializers serializers, Serializer serializer) =>
      serializers.serializeWith(serializer, this);

  Map<String, dynamic> serialize<T>(
      Serializers serializers, Serializer serializer) {
    return serializers.serializeWith(serializer, this);
  }
}
