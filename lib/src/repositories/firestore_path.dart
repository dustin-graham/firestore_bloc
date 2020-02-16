import 'package:collection/collection.dart';

abstract class FirestorePath {
  final List<String> _path;

  FirestorePath(this._path);

  String get path => _path.join('/');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FirestorePath &&
          runtimeType == other.runtimeType &&
          ListEquality().equals(this._path, other._path);

  @override
  int get hashCode => ListEquality().hash(_path);
}

class FirestoreCollectionPath extends FirestorePath {
  FirestoreCollectionPath(List<String> path)
      : assert(path.length % 2 != 0),
        // collections should be odd
        super(path);

  FirestoreCollectionPath.parse(String path) : this(path.split('/'));

  FirestoreDocumentPath get parentDocument {
    if (_path.length >= 3) {
      return FirestoreDocumentPath(_path..removeLast());
    }
    return null;
  }

  FirestoreDocumentPath document(String id) {
    return FirestoreDocumentPath(_path..add(id));
  }
}

class FirestoreDocumentPath extends FirestorePath {
  FirestoreDocumentPath(List<String> path)
      : assert(path.length % 2 == 0),
        // documents should be even
        super(path);

  String get documentId => _path.last;

  FirestoreDocumentPath.parse(String path) : this(path.split('/'));

  FirestoreCollectionPath get parentCollection {
    return FirestoreCollectionPath(_path..removeLast());
  }

  FirestoreCollectionPath collection(String collectionKey) {
    return FirestoreCollectionPath(_path..add(collectionKey));
  }
}
