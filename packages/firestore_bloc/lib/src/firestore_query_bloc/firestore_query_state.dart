import 'package:firestore_doc/firestore_doc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'firestore_query_state.freezed.dart';

@freezed
abstract class FirestoreQueryState<T extends FirestoreDocument>
    with _$FirestoreQueryState<T> {
  const factory FirestoreQueryState.uninitialized() =
      FirestoreQueryUninitializedState;

  const factory FirestoreQueryState.loading() = FirestoreQueryLoadingState;

  const factory FirestoreQueryState.loaded({@required List<T> documents}) =
      FirestoreQueryLoadedState<T>;

  const factory FirestoreQueryState.loadFailed({Object error}) =
      FirestoreQueryLoadFailedState;
}
