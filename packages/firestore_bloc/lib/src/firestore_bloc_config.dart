import 'package:built_value/serializer.dart';

class FirestoreBlocConfig {
  FirestoreBlocConfig._();

  static final FirestoreBlocConfig instance = FirestoreBlocConfig._();

  Serializers _serializers;

  Serializers get serializers => _serializers;

  void configure({Serializers serializers}) {
    _serializers = serializers;
  }
}