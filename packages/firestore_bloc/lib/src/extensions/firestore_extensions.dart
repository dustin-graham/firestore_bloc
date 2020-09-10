import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_bloc/firestore_bloc.dart';
import 'package:firestore_doc/firestore_doc.dart';

import '../firestore_bloc_config.dart';

extension DocumentSnapshotExtensions on DocumentSnapshot {
  T convert<T>(Serializer<T> serializer) {
    if (exists) {
      final dataMap = Map<String,dynamic>.of(this.data());
      dataMap['id'] = id;
      dataMap['referencePath'] = this.reference.path;
      return FirestoreBlocConfig.instance.serializers
          .deserializeWith(serializer, dataMap);
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
