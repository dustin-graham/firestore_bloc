import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../firestore_bloc.dart';
import '../firestore_document.dart';
import '../repositories/firestore_document_repository.dart';
import 'bloc.dart';

class FirestoreDocumentBloc<T extends FirestoreDocument>
    extends Bloc<FirestoreDocumentEvent, FirestoreDocumentState<T>> {
  final FirestoreCollectionRepository<T> collectionRepo;
  StreamSubscription _documentSubscription;
  FirestoreDocumentRepository _repo;
  String documentId;

  FirestoreDocumentBloc(this.collectionRepo, {this.documentId});

  @override
  Future<void> close() {
    _documentSubscription?.cancel();
    _repo?.close();
    return super.close();
  }

  @override
  FirestoreDocumentState<T> get initialState => uninitialized(documentId);

  @override
  Stream<FirestoreDocumentState<T>> mapEventToState(
      FirestoreDocumentEvent event) async* {
    if (event is FirestoreDocumentLoadRequestedEvent) {
      yield loading(event.documentId);
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
      yield loadFailed(event.error, event.documentId);
      return;
    }
    if (event is FirestoreDocumentDeletedEvent) {
      yield deleted();
      return;
    }
  }

  void _subscribeToDocumentChanges(String documentId) {
    _documentSubscription?.cancel();
    _documentSubscription = _repo.stream().listen(
      (document) {
        if (document != null) {
          add(FirestoreDocumentLoadedEvent<T>(document));
        } else {
          add(FirestoreDocumentLoadFailedEvent(
              "document not found", documentId));
        }
      },
      onError: (e) => add(FirestoreDocumentLoadFailedEvent(e, documentId)),
    );
  }

  FirestoreDocumentUninitializedState<T> uninitialized(String documentId) =>
      FirestoreDocumentUninitializedState(documentId);

  FirestoreDocumentLoadingState<T> loading(String documentId) =>
      FirestoreDocumentLoadingState(documentId);

  FirestoreDocumentUpdatingState<T> updating(T document) =>
      FirestoreDocumentUpdatingState(document);

  FirestoreDocumentLoadedState<T> loaded(T document) =>
      FirestoreDocumentLoadedState<T>(document);

  FirestoreDocumentLoadFailedState<T> loadFailed(
          Object error, String documentId) =>
      FirestoreDocumentLoadFailedState(error, documentId);

  FirestoreDocumentDeletedState<T> deleted() => FirestoreDocumentDeletedState();

  void load(String documentId) {
    assert(this.documentId == null || this.documentId == documentId);
    this.documentId = documentId;
    _repo = collectionRepo.getDocumentRepository(documentId);
    add(FirestoreDocumentLoadRequestedEvent(documentId));
    _subscribeToDocumentChanges(documentId);
  }

  Future<T> create(T document) async {
    try {
      T createdDocument = await collectionRepo.add(document);
      load(createdDocument.id);
      return createdDocument;
    } catch (e) {
      print('error creating document: $e');
      rethrow;
    }
  }

  Future<void> update(T document) async {
    assert(state is FirestoreDocumentLoadedState<T>,
        'tried to update document while not currently loaded');
    final FirestoreDocumentLoadedState<T> loadedState = state;
    assert(document.id == documentId, "updated document doesn't match");
    try {
      _documentSubscription?.cancel(); // prevent updates until we're done
      add(FirestoreDocumentUpdateRequestedEvent(document));
      await _repo.update(document);
    } catch (e) {
      rethrow;
    } finally {
      // always reconnect to the repo
      _subscribeToDocumentChanges(documentId);
    }
  }

  Future<void> delete() async {
    assert(state is FirestoreDocumentLoadedState<T>,
        'tried to update document while not currently loaded');
    final FirestoreDocumentLoadedState<T> loadedState = state;
    try {
      _documentSubscription?.cancel();
      add(FirestoreDocumentDeleteRequestedEvent(loadedState.document));
      await _repo.delete();
      add(FirestoreDocumentDeletedEvent());
    } catch (e) {
      // reconnect to the document changes on error
      _subscribeToDocumentChanges(loadedState.document.id);
      rethrow;
    }
  }
}
