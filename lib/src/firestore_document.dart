import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:firestore_bloc/src/repositories/firestore_path.dart';

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