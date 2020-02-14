import 'package:equatable/equatable.dart';

abstract class FirestoreCollectionEvent extends Equatable {
  const FirestoreCollectionEvent();

  @override
  List<Object> get props => [];
}

//class FirestoreLoadCollectionEvent extends FirestoreCollectionEvent {}

class FirestoreCollectionLoadRequestedEvent extends FirestoreCollectionEvent {}

class FirestoreCollectionLoadedEvent<T> extends FirestoreCollectionEvent {
  final List<T> documents;

  FirestoreCollectionLoadedEvent(this.documents);

  @override
  List<Object> get props => super.props..addAll([documents]);
}

class FirestoreCollectionLoadFailedEvent extends FirestoreCollectionEvent {
  final Object error;

  FirestoreCollectionLoadFailedEvent(this.error);

  @override
  List<Object> get props => super.props..addAll([error]);
}

//class FirestoreAddDocumentEvent<T> extends FirestoreCollectionEvent {
//  final T document;
//
//  FirestoreAddDocumentEvent(this.document);
//
//  @override
//  List<Object> get props => super.props..addAll([document]);
//}

class FirestoreAddedDocumentEvent<T> extends FirestoreCollectionEvent {
  final T document;

  FirestoreAddedDocumentEvent(this.document);

  @override
  List<Object> get props => super.props..addAll([document]);
}

//class FirestoreDeleteDocumentEvent extends FirestoreCollectionEvent {
//  final String id;
//
//  FirestoreDeleteDocumentEvent(this.id);
//
//  @override
//  List<Object> get props => super.props..addAll([id]);
//}
