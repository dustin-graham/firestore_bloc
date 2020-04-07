import 'package:firestore_bloc/firestore_bloc.dart';
import 'package:firestore_doc/firestore_doc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Firestore Repository', () {
    final fakeId = 'scoobydoo';

    setUp(() {
      FirestoreRepository.documentIdGenerator = () {
        return fakeId;
      };
    });

    test('safe document ID correctly generates ID when no ID set on model', () {
      final fakeDocumentNoId = FakeFirestoreDocument(null);
      expect(FirestoreRepository.safeDocumentId(fakeDocumentNoId), fakeId);
    });

    test('safe document ID correctly returns explicitly set IDs from models', () {
      final explicitId = 'scrappydoo';
      final fakeDocument = FakeFirestoreDocument(explicitId);
      expect(FirestoreRepository.safeDocumentId(fakeDocument), explicitId);
    });

    test('safe document ID returns null if no cutom ID generator is set and document does not have an ID', () {
      FirestoreRepository.documentIdGenerator = null;
      final fakeDocument = FakeFirestoreDocument(null);
      expect(FirestoreRepository.safeDocumentId(fakeDocument), null);
    });

    test('safe document ID returns explicitly set ID when no custom generatror is set', () {
      final explicitId = 'scrappydoo';
      final fakeDocument = FakeFirestoreDocument(explicitId);
      expect(FirestoreRepository.safeDocumentId(fakeDocument), explicitId);
    });
  });
}

class FakeFirestoreDocument extends FirestoreDocument {
  final String _id;

  FakeFirestoreDocument(this._id);
  @override
  String get id => _id;

  @override
  FirestoreDocument rebuild(void Function(FirestoreDocumentBuilder) updates) {
    return null;
  }

  @override
  String get referencePath => null;

  @override
  FirestoreDocumentBuilder toBuilder() {
    return null;
  }
}