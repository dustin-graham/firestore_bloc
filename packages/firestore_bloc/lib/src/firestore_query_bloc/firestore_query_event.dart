import 'package:equatable/equatable.dart';
import 'package:firestore_doc/firestore_doc.dart';

abstract class FirestoreQueryEvent extends Equatable {
  const FirestoreQueryEvent();

  @override
  List<Object> get props => [];
}

class FirestoreQueryLoadRequestedEvent extends FirestoreQueryEvent {}

class FirestoreQueryLoadedEvent<T extends FirestoreDocument>
    extends FirestoreQueryEvent {
  final List<T> documents;

  FirestoreQueryLoadedEvent(this.documents);

  @override
  List<Object> get props => super.props..addAll([documents]);
}

class FirestoreQueryLoadFailedEvent extends FirestoreQueryEvent {
  final Object error;

  FirestoreQueryLoadFailedEvent(this.error);

  @override
  List<Object> get props => super.props..addAll([error]);
}