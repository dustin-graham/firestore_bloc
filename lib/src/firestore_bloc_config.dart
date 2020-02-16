import 'package:built_value/serializer.dart';

class FirestoreBloc {
  FirestoreBloc();

  static final FirestoreBloc instance = FirestoreBloc();

  Serializers _serializers;

  Serializers get serializers => _serializers;

  void configure({Serializers serializers}) {
    _serializers = serializers;
  }
}