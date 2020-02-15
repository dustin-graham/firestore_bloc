import 'dart:async';


import '../../firestore_bloc.dart';
import '../repositories/firestore_collection_repository.dart';

typedef CustomStreamLoader<T extends FirestoreDocument> = Stream<List<T>>
    Function();

abstract class FirestoreCollectionBloc<T extends FirestoreDocument,
        R extends FirestoreCollectionRepository<T>>
    extends FirestoreQueryBloc<T, R> {
  final R collectionRepo;

  FirestoreCollectionBloc(this.collectionRepo) : super(collectionRepo);

  Future<T> addDocument(T document) async {
    try {
      T addedDocument = await collectionRepo.add(document);
      return addedDocument;
    } catch (e) {
      print('error adding document: $e');
      rethrow;
    }
  }

  Future<void> deleteDocument(String documentId) async {
    try {
      await collectionRepo.delete(documentId);
    } catch (e) {
      print('error deleting document: $e');
      rethrow;
    }
  }

  void loadAll() {
    super.load(() => collectionRepo.listAll());
  }
}
