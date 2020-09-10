import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_bloc/src/exceptions/firestore_exceptions.dart';
import 'package:firestore_bloc/src/utils/serializer_utils.dart';
import 'package:firestore_doc/firestore_doc.dart';
import 'package:quiver/strings.dart';
import 'package:rxdart/rxdart.dart';

import '../extensions/firestore_extensions.dart';
import '../firestore_bloc_config.dart';

typedef DocumentIdGenerator = String Function();

abstract class FirestoreRepository<T extends FirestoreDocument> {
  /// Set this if you want a way to manually determine ahead of time the document ID going into the database
  static DocumentIdGenerator documentIdGenerator;

  static FirebaseFirestore _firestoreInstance;

  /// set this if you have a custom firestore app you need to reference instead
  /// of the default
  static set firestoreInstance(FirebaseFirestore instance) {
    _firestoreInstance = instance;
  }

  static FirebaseFirestore get firestoreInstance =>
      _firestoreInstance ?? FirebaseFirestore.instance;

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
      return snapshot.docs
          .where((documentSnapshot) =>
              documentSnapshot.data != null &&
              documentIsValid(documentSnapshot.data()))
          .map<T>(deserializeSnapshot)
          .toList();
    };
    final singleFetchStream =
        Stream.fromFuture(query.get(GetOptions(source: Source.server)));
    final snapshotsStream = query.snapshots();
    return MergeStream([singleFetchStream, snapshotsStream]).map(mapSnapshots);
  }

  Future<T> querySingle(Query query) {
    return query.limit(1).get().then((snapshot) {
      if (snapshot.docs.length == 0) {
        return null;
      }

      var documentSnapshot = snapshot.docs.first;
      return documentSnapshot.convert(serializer);
    });
  }

  Stream<T> documentSnapshots(FirestoreDocumentPath path) {
    final singleFetchStream = Stream.fromFuture(path.documentReference.get());
    final snapshotsStream = path.documentReference.snapshots();
    return MergeStream([singleFetchStream, snapshotsStream])
        .map(deserializeSnapshot);
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

  /// pass in an [originalDocument] if you would like this method to automatically
  /// determine which fields have been removed so and pass in a [FieldValue.delete()]
  Future<void> updateDocument(T document,
      {bool merge = false, T originalDocument}) async {
    if (isBlank(document.referencePath)) {
      throw NoDocumentReferenceException(
          'tried to update document without a reference');
    }

    var serializedDocument = FirestoreBlocConfig.instance.serializers
        .serializeWith(serializer, document);
    if (originalDocument != null) {
      final originalSerializedDocument = FirestoreBlocConfig
          .instance.serializers
          .serializeWith(serializer, originalDocument);

      final processedUpdate =
          processMissingFields(serializedDocument, originalSerializedDocument);

      await FirestoreRepository.firestoreInstance
          .doc(document.referencePath)
          .set(processedUpdate, SetOptions(merge: true));
    } else {
      await FirestoreRepository.firestoreInstance
          .doc(document.referencePath)
          .set(serializedDocument, SetOptions(merge: merge));
    }
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
        await referencePath.documentReference.set(FirestoreBlocConfig
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
    return FirestoreRepository.firestoreInstance.doc(path);
  }
}
