import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'firestore_document.g.dart';

@BuiltValue(instantiable: false)
abstract class FirestoreDocument {
  @nullable
  @BuiltValueField()
  String get id;

  FirestoreDocument rebuild(void Function(FirestoreDocumentBuilder) updates);

  FirestoreDocumentBuilder toBuilder();
}

extension FirestoreDocumentExtensions on FirestoreDocument {
  Map<String, dynamic> serialize<T>(
      Serializers serializers, Serializer serializer) {
    return serializers.serializeWith(serializer, this);
  }
}
