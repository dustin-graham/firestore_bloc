import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_bloc/firestore_bloc.dart';
import 'package:quiver/strings.dart';

import '../extensions/firestore_extensions.dart';
import '../firestore_document.dart';
import 'basic_document_repository.dart';
import 'firestore_document_repository.dart';
import 'firestore_query_repository.dart';

abstract class FirestoreCollectionRepository<T extends FirestoreDocument>
    extends FirestoreQueryRepository<T> {
  /// used for mutating: adding/deleting from the collection
  CollectionReference get collectionRef;

  Serializer<T> get serializer;

  T deserializeSnapshot(DocumentSnapshot snapshot) {
    return snapshot.convert(FirestoreBloc.instance.serializers, serializer);
  }

  Future<T> add(T t) async {
    try {
      if (isNotEmpty(t.id)) {
        await collectionRef
            .document(t.id)
            .setData(FirestoreBloc.instance.serializers.serializeWith(serializer, t));
        return t;
      }
      var docRef =
          await collectionRef.add(FirestoreBloc.instance.serializers.serializeWith(serializer, t));
      var docSnapshot = await docRef.get();
      return deserializeSnapshot(docSnapshot);
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Query get query => collectionRef;

  Future<void> delete(String id) {
    return collectionRef.document(id).delete();
  }

  FirestoreDocumentRepository getDocumentRepository(String documentId) {
    return BasicDocumentRepository(collectionRef, documentId, serializer);
  }
}
