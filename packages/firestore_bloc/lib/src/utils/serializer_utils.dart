import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiver/strings.dart';

/// Any missing fields in the updated document that were present in the original
/// document will be added as [FieldValue.delete()] sentinel values
Map<String, dynamic> processMissingFields(Map<String, dynamic> updatedDocument,
    Map<String, dynamic> originalDocument) {
  final deletedKeys = _deletedKeys(updatedDocument, originalDocument, '');
  final deletedKeyMap = Map<String, dynamic>.fromIterable(deletedKeys,
      key: (key) => key, value: (key) => FieldValue.delete());
  return updatedDocument..addAll(deletedKeyMap);
}

List<String> _deletedKeys(Map<String, dynamic> updatedDocument,
    Map<String, dynamic> originalDocument, String baseKeyPath) {
  assert(baseKeyPath != null);
  final deletedKeys = <String>[];
  final originalKeys = originalDocument.keys.toList();
  for (final originalKey in originalKeys) {
    final keyPath = '${isBlank(baseKeyPath) ? '' : '$baseKeyPath.'}$originalKey';
    final updatedValue = updatedDocument[originalKey];
    if (updatedValue == null) {
      deletedKeys.add(keyPath);
    } else if (updatedValue is Map) {
      deletedKeys.addAll(
          _deletedKeys(updatedValue, originalDocument[originalKey], keyPath));
    }
  }
  return deletedKeys;
}
