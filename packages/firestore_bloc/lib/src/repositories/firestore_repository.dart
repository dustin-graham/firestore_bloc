import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_bloc/src/exceptions/firestore_exceptions.dart';
import 'package:firestore_doc/firestore_doc.dart';
import 'package:quiver/strings.dart';
import 'package:rxdart/rxdart.dart';

import '../extensions/firestore_extensions.dart';
import '../firestore_bloc_config.dart';

typedef DocumentIdGenerator = String Function();

abstract class FirestoreRepository<T extends FirestoreDocument> {
  /// Set this if you want a way to manually determine ahead of time the document ID going into the database
  static DocumentIdGenerator documentIdGenerator;

  static Firestore _firestoreInstance;

  /// set this if you have a custom firestore app you need to reference instead
  /// of the default
  static set firestoreInstance(Firestore instance) {
    _firestoreInstance = instance;
  }

  static Firestore get firestoreInstance =>
      _firestoreInstance ?? Firestore.instance;

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
    await FirestoreRepository.firestoreInstance
        .document(document.referencePath)
        .setData(FirestoreBlocConfig.instance.serializers
            .serializeWith(serializer, document));
  }

  Future<void> deleteDocument(FirestoreDocumentPath path) {
    return path.documentReference.delete();
  }

  static String safeDocumentId(FirestoreDocument document) {
    return isNotEmpty(document.id)
        ? document.id
        : documentIdGenerator != null ? documentIdGenerator() : null;
  }

  Future<T> addDocument(FirestoreCollectionPath collectionPath, T t) async {
    try {
      var existingDocumentId = safeDocumentId(t);
      if (existingDocumentId != null) {
        // for consistency, just in case this wasn't set already
        t = t.rebuild((b) {
          b.id = existingDocumentId;
        });
        var referencePath = collectionPath.document(existingDocumentId);
        await referencePath.documentReference.setData(FirestoreBlocConfig
            .instance.serializers
            .serializeWith(serializer, t));
        return t.rebuild((b) {
          b.referencePath = referencePath.path;
        });
      }
      var docRef = await collectionPath.collectionReference.add(
          FirestoreBlocConfig.instance.serializers
              .serializeWith(serializer, t));
      var docSnapshot = await docRef.get();
      return deserializeSnapshot(docSnapshot);
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}

extension FirestoreCollectionPathExtensions on FirestoreCollectionPath {
  CollectionReference get collectionReference {
    return FirestoreRepository.firestoreInstance.collection(path);
  }
}

extension FirestoreDocumentPathExtensions on FirestoreDocumentPath {
  DocumentReference get documentReference {
    return FirestoreRepository.firestoreInstance.document(path);
  }
}
