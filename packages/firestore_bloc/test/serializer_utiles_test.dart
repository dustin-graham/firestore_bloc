import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_bloc/src/utils/serializer_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('removeNulls', () {
    test('correctly adds sentinel values', () {
      final originalDocument = <String, dynamic>{
        'name': 'Dustin',
        'occupation': {
          'name': 'programmer',
          'enjoyment': 100,
          'stress': 50
        },
        'hobbies': [
          'skiing',
          'mountain biking',
          'boating',
        ],
      };
      final updatedDocument = <String, dynamic>{
        'occupation': {
          'name': 'programmer',
          'enjoyment': 100,
        },
        'hobbies': [
          'skiing',
          'boating',
        ],
      };
      // FieldValues can only show up as top level fields so dot-notation is required
      // We are currently sending arrays as whole lists, so nothing to do with removed array keys
      final expectedJson = <String, dynamic>{
        'name': FieldValue.delete(),
        'occupation.stress': FieldValue.delete(),
        'occupation': {
          'name': 'programmer',
          'enjoyment': 100,
        },
        'hobbies': [
          'skiing',
          'boating',
        ],
      };

      final actualJson = processMissingFields(updatedDocument, originalDocument);
      expect(actualJson, expectedJson);
    });
  });
}