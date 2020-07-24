import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firestore_bloc/src/firestore_document_bloc/firestore_document_state.dart';
import 'package:firestore_bloc/src/repositories/firestore_repository.dart';
import 'package:firestore_doc/firestore_doc.dart';

class FirestoreDocumentCubit<T extends FirestoreDocument>
    extends Cubit<FirestoreDocumentState<T>> {
  final FirestoreRepository<T> collectionRepo;
  StreamSubscription _documentSubscription;
  FirestoreDocumentPath documentPath;
  FirestoreCollectionPath parentCollectionPath;

  FirestoreDocumentCubit(this.collectionRepo, this.parentCollectionPath,
      {this.documentPath, FirestoreDocumentState<T> initialState})
      : super(
            initialState ?? FirestoreDocumentUninitializedState(documentPath));

  @override
  Future<void> close() {
    _documentSubscription?.cancel();
    return super.close();
  }

  void _subscribeToDocumentChanges(FirestoreDocumentPath path) {
    _documentSubscription?.cancel();
    _documentSubscription = collectionRepo.documentSnapshots(path).listen(
      (document) {
        if (document != null) {
          emit(loaded(document));
        } else {
          emit(loadFailed("document not found", documentPath));
        }
      },
      onError: (e) {
        emit(loadFailed(e, documentPath));
      },
    );
  }

  FirestoreDocumentUninitializedState<T> uninitialized(
          FirestoreDocumentPath documentId) =>
      FirestoreDocumentUninitializedState(documentId);

  FirestoreDocumentLoadingState<T> loading(FirestoreDocumentPath documentId) =>
      FirestoreDocumentLoadingState(documentId);

  FirestoreDocumentUpdatingState<T> updating(T document) =>
      FirestoreDocumentUpdatingState(document);

  FirestoreDocumentLoadedState<T> loaded(T document) =>
      FirestoreDocumentLoadedState<T>(document);

  FirestoreDocumentLoadFailedState<T> loadFailed(
          Object error, FirestoreDocumentPath documentId) =>
      FirestoreDocumentLoadFailedState(error, documentId);

  FirestoreDocumentDeletedState<T> deleted() => FirestoreDocumentDeletedState();

  void load() {
    assert(documentPath != null);
    emit(loading(documentPath));
    _subscribeToDocumentChanges(documentPath);
  }

  Future<T> create(T document) async {
    try {
      T createdDocument =
          await collectionRepo.addDocument(parentCollectionPath, document);
      documentPath = FirestoreDocumentPath.parse(createdDocument.referencePath);
      load();
      return createdDocument;
    } catch (e) {
      print('error creating document: $e');
      rethrow;
    }
  }

  Future<void> update(T document,
      {bool merge = false, T originalDocument}) async {
    assert(state is FirestoreDocumentLoadedState<T>,
        'tried to update document while not currently loaded');
    assert(document.path == documentPath, "updated document doesn't match");
    try {
      _documentSubscription?.cancel(); // prevent updates until we're done
      emit(updating(document));
      await collectionRepo.updateDocument(
        document,
        merge: merge,
        originalDocument: originalDocument,
      );
    } catch (e) {
      rethrow;
    } finally {
      // always reconnect to the repo
      _subscribeToDocumentChanges(
          FirestoreDocumentPath.parse(document.referencePath));
    }
  }

  Future<void> delete() async {
    assert(documentPath != null);
    assert(state is FirestoreDocumentLoadedState<T>,
        'tried to update document while not currently loaded');
    final FirestoreDocumentLoadedState<T> loadedState = state;
    try {
      _documentSubscription?.cancel();
      await collectionRepo.deleteDocument(documentPath);
      emit(deleted());
    } catch (e) {
      // reconnect to the document changes on error
      _subscribeToDocumentChanges(loadedState.document.path);
      rethrow;
    }
  }
}
