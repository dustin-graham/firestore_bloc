import 'package:equatable/equatable.dart';
import 'package:firestore_doc/firestore_doc.dart';

abstract class FirestoreQueryState extends Equatable {
  const FirestoreQueryState();

  @override
  List<Object> get props => [];
}

class FirestoreQueryUninitializedState extends FirestoreQueryState {}

class FirestoreQueryLoadingState extends FirestoreQueryState {}

class FirestoreQueryLoadFailedState extends FirestoreQueryState {
  final Object error;

  FirestoreQueryLoadFailedState(this.error);

  @override
  List<Object> get props => super.props..addAll([error]);
}

class FirestoreQueryLoadedState<T extends FirestoreDocument>
    extends FirestoreQueryState {
  final List<T> documents;

  FirestoreQueryLoadedState(this.documents);

  @override
  List<Object> get props => super.props..addAll([documents]);
}

class FirestoreQueryDocumentAddedState<T extends FirestoreDocument>
    extends FirestoreQueryState {
  final T document;

  FirestoreQueryDocumentAddedState(this.document);

  @override
  List<Object> get props => super.props..addAll([document]);
}
