import 'package:built_value/serializer.dart';

/// Erase the "referencePath" property of [FirestoreDocument] so that it doesn't get written
/// into the actual firebase documents. This path generated and maintained
/// by firebase and we map it into the [FirestoreDocument.referencePath] field for convenience
/// we don't want to send this value back over the wire when we make updates
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
        final referencePathIndex = elements.indexOf('referencePath');
        if (referencePathIndex >= 0) {
          elements.removeRange(referencePathIndex, referencePathIndex + 2);
        }
        return elements;
      } catch (e) {
        print(
            'error stripping out firestore document metadat on ${specifiedType.root}, e: $e');
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
