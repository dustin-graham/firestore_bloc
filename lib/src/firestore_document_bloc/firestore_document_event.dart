import 'package:equatable/equatable.dart';
import 'package:firestore_bloc/src/repositories/firestore_path.dart';

import '../firestore_document.dart';

abstract class FirestoreDocumentEvent extends Equatable {
  @override
  List<Object> get props {
    return [];
  }
}

class FirestoreDocumentLoadRequestedEvent extends FirestoreDocumentEvent {
  final FirestoreDocumentPath documentPath;

  FirestoreDocumentLoadRequestedEvent(this.documentPath);
}

class FirestoreDocumentLoadedEvent<T extends FirestoreDocument>
    extends FirestoreDocumentEvent {
  final T document;

  FirestoreDocumentLoadedEvent(this.document);

  @override
  List<Object> get props => super.props..addAll([document]);
}

class FirestoreDocumentUpdateRequestedEvent<T extends FirestoreDocument>
    extends FirestoreDocumentLoadedEvent<T> {
  FirestoreDocumentUpdateRequestedEvent(T document) : super(document);
}

class FirestoreDocumentDeleteRequestedEvent<T extends FirestoreDocument>
    extends FirestoreDocumentLoadedEvent<T> {
  FirestoreDocumentDeleteRequestedEvent(T document) : super(document);
}

class FirestoreDocumentDeletedEvent extends FirestoreDocumentEvent {}

class FirestoreDocumentLoadFailedEvent extends FirestoreDocumentEvent {
  final FirestoreDocumentPath documentPath;
  final Object error;

  FirestoreDocumentLoadFailedEvent(this.error, this.documentPath);

  @override
  List<Object> get props => super.props..addAll([error]);
}
