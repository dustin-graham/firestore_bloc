import 'package:built_value/built_value.dart';

import 'firestore_path.dart';

part 'firestore_document.g.dart';

@BuiltValue(instantiable: false)
abstract class FirestoreDocument {
  @nullable
  @BuiltValueField()
  String get id;

  @nullable
  String get referencePath;

  FirestoreDocumentPath get path => referencePath != null ? FirestoreDocumentPath.parse(referencePath) : null;

  FirestoreDocument rebuild(void Function(FirestoreDocumentBuilder) updates);

  FirestoreDocumentBuilder toBuilder();
}