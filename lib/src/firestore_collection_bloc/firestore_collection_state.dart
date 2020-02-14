import 'package:equatable/equatable.dart';

abstract class FirestoreCollectionState extends Equatable {
  const FirestoreCollectionState();

  @override
  List<Object> get props => [];
}

class FirestoreCollectionUninitializedState extends FirestoreCollectionState {}

class FirestoreCollectionLoadingState extends FirestoreCollectionState {}

class FirestoreCollectionLoadFailedState extends FirestoreCollectionState {
  final Object error;

  FirestoreCollectionLoadFailedState(this.error);

  @override
  List<Object> get props => super.props..addAll([error]);
}

class FirestoreCollectionLoadedState<T> extends FirestoreCollectionState {
  final List<T> documents;

  FirestoreCollectionLoadedState(this.documents);

  @override
  List<Object> get props => super.props..addAll([documents]);
}

class FirestoreCollectionDocumentAddedState<T>
    extends FirestoreCollectionState {
  final T document;

  FirestoreCollectionDocumentAddedState(this.document);

  @override
  List<Object> get props => super.props..addAll([document]);
}
