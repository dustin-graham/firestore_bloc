import 'package:built_value/serializer.dart';

/// Erase the "id" property of [FirestoreDocument] so that it doesn't get written
/// into the actual firebase documents. these identifiers are generated and maintained
/// by firebase and we map them into the [FirestoreDocument.id] field for convenience
/// we don't want to send these values back over the wire when we make updates
class FirestoreDocumentPlugin extends SerializerPlugin {
  final List<Type> documentTypes;

  FirestoreDocumentPlugin(this.documentTypes);

  @override
  Object afterDeserialize(Object object, FullType specifiedType) {
    return object;
  }

  @override
  Object afterSerialize(Object object, FullType specifiedType) {
    if (documentTypes.contains(specifiedType.root)) {
      try {
        var elements = List.of(object);
        final idIndex = elements.indexOf('id');
        elements.removeRange(idIndex, idIndex + 2);
        final referencePathIndex = elements.indexOf('referencePath');
        elements.removeRange(referencePathIndex, referencePathIndex + 2);
        return elements;
      } catch (_) {
        return object;
      }
    }
    return object;
  }

  @override
  Object beforeDeserialize(Object object, FullType specifiedType) {
    return object;
  }

  @override
  Object beforeSerialize(Object object, FullType specifiedType) {
    return object;
  }
}