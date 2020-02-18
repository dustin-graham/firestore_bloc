import 'package:equatable/equatable.dart';
import 'package:firestore_doc/firestore_doc.dart';

abstract class FirestoreDocumentState<T extends FirestoreDocument>
    extends Equatable {
  /// nullable, this is an indicator whether or not we will be observing a
  /// document that already exists or not
  FirestoreDocumentPath get documentPath => null;

  @override
  List<Object> get props => [];

  bool get isCreationState => false;
}

class FirestoreDocumentUninitializedState<T extends FirestoreDocument>
    extends FirestoreDocumentState<T> {
  @override
  final FirestoreDocumentPath documentPath;

  FirestoreDocumentUninitializedState(this.documentPath);

  @override
  bool get isCreationState => documentPath == null;
}

class FirestoreDocumentCreationFailedState<T extends FirestoreDocument>
    extends FirestoreDocumentState<T> {
  final dynamic error;

  FirestoreDocumentCreationFailedState(this.error);

  @override
  List<Object> get props => super.props..add(error);
}

abstract class FirestoreDocumentBlocInitializedState<
    T extends FirestoreDocument> extends FirestoreDocumentState<T> {
  @override
  final FirestoreDocumentPath documentPath;

  FirestoreDocumentBlocInitializedState(this.documentPath);

  @override
  List<Object> get props => super.props..add(documentPath);
}

class FirestoreDocumentLoadingState<T extends FirestoreDocument>
    extends FirestoreDocumentBlocInitializedState<T> {
  FirestoreDocumentLoadingState(FirestoreDocumentPath documentId) : super(documentId);
}

class FirestoreDocumentLoadFailedState<T extends FirestoreDocument>
    extends FirestoreDocumentBlocInitializedState<T> {
  final Object error;

  FirestoreDocumentLoadFailedState(this.error, FirestoreDocumentPath documentId)
      : super(documentId);

  @override
  List<Object> get props => super.props..addAll([error]);

  @override
  String toString() {
    return 'FirebaseDocumentStateLoadFailed {error: $error}';
  }
}

class FirestoreDocumentLoadedState<T extends FirestoreDocument>
    extends FirestoreDocumentBlocInitializedState<T> {
  final T document;

  FirestoreDocumentLoadedState(this.document)
      : assert(document != null),
        super(document.path);

  @override
  List<Object> get props => super.props..addAll([document]);
}

class FirestoreDocumentUpdatingState<T extends FirestoreDocument>
    extends FirestoreDocumentLoadedState<T> {
  FirestoreDocumentUpdatingState(T document) : super(document);
}

class FirestoreDocumentDeletedState<T extends FirestoreDocument>
    extends FirestoreDocumentState<T> {}
