library firestore_bloc;

import 'package:built_value/serializer.dart';

export 'src/firestore_collection_bloc/bloc.dart';
export 'src/firestore_document_bloc/bloc.dart';
export 'src/repositories/firestore_collection_repository.dart';
export 'src/repositories/firestore_document_repository.dart';
export 'src/repositories/firestore_query_repository.dart';

class FirestoreBloc {
  FirestoreBloc();

  static final FirestoreBloc instance = FirestoreBloc();

  Serializers _serializers;
  Serializers get serializers => _serializers;

  void configure({Serializers serializers}) {
    _serializers = serializers;
  }
}