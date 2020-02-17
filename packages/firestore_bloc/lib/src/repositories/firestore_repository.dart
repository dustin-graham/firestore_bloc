import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_bloc/src/exceptions/firestore_exceptions.dart';
import 'package:firestore_doc/firestore_doc.dart';
import '../extensions/firestore_extensions.dart';
import 'package:quiver/strings.dart';
import 'package:rxdart/rxdart.dart';

import '../firestore_bloc_config.dart';

abstract class FirestoreRepository<T extends FirestoreDocument> {
  Serializer<T> get serializer;

  T deserializeSnapshot(DocumentSnapshot snapshot) {
    return snapshot.convert(serializer);
  }

  bool documentIsValid(Map<String, dynamic> documentData) {
    return true;
  }

  Stream<List<T>> queryAll(FirestoreCollectionPath collectionPath) {
    return querySnapshots(collectionPath.collectionReference);
  }

  Stream<List<T>> querySnapshots(Query query) {
    final mapSnapshots = (QuerySnapshot snapshot) {
      return snapshot.documents
          .where((documentSnapshot) =>
              documentSnapshot.data != null &&
              documentIsValid(documentSnapshot.data))
          .map<T>(deserializeSnapshot)
          .toList();
    };
    final singleFetchStream =
        Stream.fromFuture(query.getDocuments(source: Source.server));
    final snapshotsStream = query.snapshots();
    return MergeStream([singleFetchStream, snapshotsStream]).map(mapSnapshots);
  }

  Future<T> querySingle(Query query) {
    return query.limit(1).getDocuments().then((snapshot) {
      if (snapshot.documents.length == 0) {
        return null;
      }

      var documentSnapshot = snapshot.documents.first;
      return documentSnapshot.convert(serializer);
    });
  }

  Stream<T> documentSnapshots(FirestoreDocumentPath path) {
    return path.documentReference.snapshots().map(deserializeSnapshot);
  }

  Future<T> getDocument(FirestoreDocumentPath path) async {
    final snapshot = await path.documentReference.get();
    if (snapshot.exists) {
      return snapshot.convert(serializer);
    }
    return null;
  }

  Future<bool> documentExists(FirestoreDocumentPath path) async {
    return (await getDocument(path)) != null;
  }

  Future<void> updateDocument(T document) async {
    if (isBlank(document.referencePath)) {
      throw NoDocumentReferenceException(
          'tried to update document without a reference');
    }
    await Firestore.instance.document(document.referencePath).setData(
        FirestoreBloc.instance.serializers.serializeWith(serializer, document));
  }

  Future<void> deleteDocument(FirestoreDocumentPath path) {
    return path.documentReference.delete();
  }

  Future<T> addDocument(FirestoreCollectionPath collectionPath, T t) async {
    try {
      if (isNotEmpty(t.id)) {
        await collectionPath.document(t.id).documentReference.setData(
            FirestoreBloc.instance.serializers.serializeWith(serializer, t));
        return t;
      }
      var docRef = await collectionPath.collectionReference
          .add(FirestoreBloc.instance.serializers.serializeWith(serializer, t));
      var docSnapshot = await docRef.get();
      return deserializeSnapshot(docSnapshot);
    } catch (e) {
      print(e);
      return null;
    }
  }
}

extension FirestoreCollectionPathExtensions on FirestoreCollectionPath {
  CollectionReference get collectionReference {
    return Firestore.instance.collection(path);
  }
}

extension FirestoreDocumentPathExtensions on FirestoreDocumentPath {
  DocumentReference get documentReference {
    return Firestore.instance.document(path);
  }
}
