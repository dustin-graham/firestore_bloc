import 'dart:async';

import 'package:bloc/bloc.dart';

import '../firestore_document.dart';
import '../repositories/firestore_collection_repository.dart';
import 'firestore_collection_event.dart';
import 'firestore_collection_state.dart';

typedef CustomStreamLoader<T extends FirestoreDocument> = Stream<List<T>>
    Function();

abstract class FirestoreCollectionBloc<T extends FirestoreDocument,
        R extends FirestoreCollectionRepository<T>>
    extends Bloc<FirestoreCollectionEvent, FirestoreCollectionState> {
  final R collectionRepo;
  StreamSubscription _streamSubscription;

  FirestoreCollectionBloc(this.collectionRepo);

  @override
  FirestoreCollectionState get initialState => uninitialized();

  @override
  Stream<FirestoreCollectionState> mapEventToState(
    FirestoreCollectionEvent event,
  ) async* {
    if (event is FirestoreCollectionLoadRequestedEvent) {
      yield loading();
      return;
    }
    if (event is FirestoreCollectionLoadFailedEvent) {
      yield* _mapFirestoreCollectionLoadFailedEventToState(event);
      return;
    }
    if (event is FirestoreCollectionLoadedEvent) {
      yield* _mapFirestoreCollectionLoadedEventToState(event);
      return;
    }
    if (event is FirestoreAddedDocumentEvent) {
      yield* _mapFirestoreAddedDocumentEventToState(event);
      return;
    }
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }

  FirestoreCollectionUninitializedState uninitialized() =>
      FirestoreCollectionUninitializedState();

  FirestoreCollectionLoadingState loading() =>
      FirestoreCollectionLoadingState();

  FirestoreCollectionLoadFailedState loadFailed(error) =>
      FirestoreCollectionLoadFailedState(error);

  FirestoreCollectionLoadedState<T> loaded(List<T> documents) =>
      FirestoreCollectionLoadedState<T>(documents);

  Stream<FirestoreCollectionState>
      _mapFirestoreCollectionLoadFailedEventToState(
          FirestoreCollectionLoadFailedEvent event) async* {
    print("firebase collection load failed: ${event.error}");
    yield loadFailed(event.error);
  }

  Stream<FirestoreCollectionState> _mapFirestoreCollectionLoadedEventToState(
      FirestoreCollectionLoadedEvent event) async* {
    yield loaded(event.documents);
  }

  Stream<FirestoreCollectionState> _mapFirestoreAddedDocumentEventToState(
      FirestoreAddedDocumentEvent event) async* {
    yield FirestoreCollectionDocumentAddedState<T>(event.document);
  }

  void _subscribeToCollection([CustomStreamLoader streamLoader]) {
    Stream<List<T>> collectionStream =
        streamLoader?.call() ?? collectionRepo.list();
    _streamSubscription?.cancel();
    _streamSubscription = collectionStream.listen((documents) {
      add(FirestoreCollectionLoadedEvent(documents));
    }, onError: (e) {
      add(FirestoreCollectionLoadFailedEvent(e));
    });
  }

  Future<void> load([CustomStreamLoader streamLoader]) async {
    add(FirestoreCollectionLoadRequestedEvent());
    _subscribeToCollection();
  }

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
}
