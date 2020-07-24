import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firestore_bloc/src/firestore_query_bloc/firestore_query_state.dart';
import 'package:firestore_bloc/src/repositories/firestore_repository.dart';
import 'package:firestore_doc/firestore_doc.dart';

typedef StreamLoader<T extends FirestoreDocument> = Stream<List<T>> Function();

abstract class FirestoreQueryCubit<T extends FirestoreDocument,
R extends FirestoreRepository<T>> extends Cubit<FirestoreQueryState> {
  final R collectionRepo;
  StreamSubscription _streamSubscription;

  FirestoreQueryCubit(this.collectionRepo, {FirestoreQueryState initialState})
      : super(initialState ?? FirestoreQueryUninitializedState());

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }

  FirestoreQueryUninitializedState uninitialized() =>
      FirestoreQueryUninitializedState();

  FirestoreQueryLoadingState loading() => FirestoreQueryLoadingState();

  FirestoreQueryLoadFailedState loadFailed(error) =>
      FirestoreQueryState.loadFailed(error: error);

  FirestoreQueryLoadedState<T> loaded(List<T> documents) =>
      FirestoreQueryState.loaded(documents: documents);

  void _subscribeToQuery(StreamLoader streamLoader) {
    Stream<List<T>> collectionStream = streamLoader?.call();
    _streamSubscription?.cancel();
    _streamSubscription = collectionStream.listen((documents) {
      emit(loaded(documents));
    }, onError: (e) {
      emit(loadFailed(e));
    });
  }

  Future<void> load(StreamLoader<T> streamLoader) async {
    emit(loading());
    _subscribeToQuery(streamLoader);
  }
}
