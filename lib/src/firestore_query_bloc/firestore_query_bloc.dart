import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../firestore_bloc.dart';

typedef StreamLoader<T extends FirestoreDocument> = Stream<List<T>> Function();

abstract class FirestoreQueryBloc<T extends FirestoreDocument,
        R extends FirestoreRepository<T>>
    extends Bloc<FirestoreQueryEvent, FirestoreQueryState> {
  final R collectionRepo;
  StreamSubscription _streamSubscription;

  FirestoreQueryBloc(this.collectionRepo);

  @override
  FirestoreQueryState get initialState => uninitialized();

  @override
  Stream<FirestoreQueryState> mapEventToState(
    FirestoreQueryEvent event,
  ) async* {
    if (event is FirestoreQueryLoadRequestedEvent) {
      yield loading();
      return;
    }
    if (event is FirestoreQueryLoadFailedEvent) {
      yield* _mapFirestoreQueryLoadFailedEventToState(event);
      return;
    }
    if (event is FirestoreQueryLoadedEvent) {
      yield* _mapFirestoreQueryLoadedEventToState(event);
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

  FirestoreQueryUninitializedState uninitialized() =>
      FirestoreQueryUninitializedState();

  FirestoreQueryLoadingState loading() => FirestoreQueryLoadingState();

  FirestoreQueryLoadFailedState loadFailed(error) =>
      FirestoreQueryLoadFailedState(error);

  FirestoreQueryLoadedState<T> loaded(List<T> documents) =>
      FirestoreQueryLoadedState<T>(documents);

  Stream<FirestoreQueryState> _mapFirestoreQueryLoadFailedEventToState(
      FirestoreQueryLoadFailedEvent event) async* {
    print("firebase collection load failed: ${event.error}");
    yield loadFailed(event.error);
  }

  Stream<FirestoreQueryState> _mapFirestoreQueryLoadedEventToState(
      FirestoreQueryLoadedEvent event) async* {
    yield loaded(event.documents);
  }

  Stream<FirestoreQueryState> _mapFirestoreAddedDocumentEventToState(
      FirestoreAddedDocumentEvent event) async* {
    yield FirestoreQueryDocumentAddedState<T>(event.document);
  }

  void _subscribeToQuery(StreamLoader streamLoader) {
    Stream<List<T>> collectionStream = streamLoader?.call();
    _streamSubscription?.cancel();
    _streamSubscription = collectionStream.listen((documents) {
      add(FirestoreQueryLoadedEvent(documents));
    }, onError: (e) {
      add(FirestoreQueryLoadFailedEvent(e));
    });
  }

  Future<void> load(StreamLoader<T> streamLoader) async {
    add(FirestoreQueryLoadRequestedEvent());
    _subscribeToQuery(streamLoader);
  }
}
