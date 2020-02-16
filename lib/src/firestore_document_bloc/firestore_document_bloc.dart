import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firestore_bloc/src/repositories/firestore_path.dart';
import 'package:firestore_bloc/src/repositories/firestore_repository.dart';

import '../../firestore_bloc.dart';
import '../firestore_document.dart';
import 'bloc.dart';

class FirestoreDocumentBloc<T extends FirestoreDocument>
    extends Bloc<FirestoreDocumentEvent, FirestoreDocumentState<T>> {
  final FirestoreRepository<T> collectionRepo;
  StreamSubscription _documentSubscription;
  FirestoreDocumentPath documentPath;
  FirestoreCollectionPath parentCollectionPath;

  FirestoreDocumentBloc(this.collectionRepo, this.parentCollectionPath,
      {this.documentPath});

  @override
  Future<void> close() {
    _documentSubscription?.cancel();
    return super.close();
  }

  @override
  FirestoreDocumentState<T> get initialState => uninitialized(documentPath);

  @override
  Stream<FirestoreDocumentState<T>> mapEventToState(
      FirestoreDocumentEvent event) async* {
    if (event is FirestoreDocumentLoadRequestedEvent) {
      yield loading(event.documentPath);
      return;
    }
    if (event is FirestoreDocumentUpdateRequestedEvent<T>) {
      yield updating(event.document);
      return;
    }
    if (event is FirestoreDocumentLoadedEvent<T>) {
      yield loaded(event.document);
      return;
    }
    if (event is FirestoreDocumentLoadFailedEvent) {
      yield loadFailed(event.error, event.documentPath);
      return;
    }
    if (event is FirestoreDocumentDeletedEvent) {
      yield deleted();
      return;
    }
  }

  void _subscribeToDocumentChanges(FirestoreDocumentPath path) {
    _documentSubscription?.cancel();
    _documentSubscription = collectionRepo.documentSnapshots(path).listen(
      (document) {
        if (document != null) {
          add(FirestoreDocumentLoadedEvent<T>(document));
        } else {
          add(FirestoreDocumentLoadFailedEvent(
              "document not found", documentPath));
        }
      },
      onError: (e) => add(FirestoreDocumentLoadFailedEvent(e, documentPath)),
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

  void load(FirestoreDocumentPath path) {
    assert(this.documentPath == null || this.documentPath == documentPath);
    this.documentPath = documentPath;
    add(FirestoreDocumentLoadRequestedEvent(documentPath));
    _subscribeToDocumentChanges(path);
  }

  Future<T> create(T document) async {
    try {
      T createdDocument =
          await collectionRepo.addDocument(parentCollectionPath, document);
      load(FirestoreDocumentPath.parse(createdDocument.referencePath));
      return createdDocument;
    } catch (e) {
      print('error creating document: $e');
      rethrow;
    }
  }

  Future<void> update(T document) async {
    assert(state is FirestoreDocumentLoadedState<T>,
        'tried to update document while not currently loaded');
    assert(document.path == documentPath, "updated document doesn't match");
    try {
      _documentSubscription?.cancel(); // prevent updates until we're done
      add(FirestoreDocumentUpdateRequestedEvent(document));
      await collectionRepo.updateDocument(document);
    } catch (e) {
      rethrow;
    } finally {
      // always reconnect to the repo
      _subscribeToDocumentChanges(
          FirestoreDocumentPath.parse(document.referencePath));
    }
  }

  Future<void> delete(FirestoreDocumentPath path) async {
    assert(state is FirestoreDocumentLoadedState<T>,
        'tried to update document while not currently loaded');
    final FirestoreDocumentLoadedState<T> loadedState = state;
    try {
      _documentSubscription?.cancel();
      add(FirestoreDocumentDeleteRequestedEvent(loadedState.document));
      await collectionRepo.deleteDocument(path);
      add(FirestoreDocumentDeletedEvent());
    } catch (e) {
      // reconnect to the document changes on error
      _subscribeToDocumentChanges(loadedState.document.path);
      rethrow;
    }
  }
}
