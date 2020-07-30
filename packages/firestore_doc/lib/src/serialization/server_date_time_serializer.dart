import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:firestore_doc/src/firestore_doc_config.dart';

/// This sends the server a FieldValue.
///
/// NOTE: This needs to be added in every client app's serializer setup
/// This is because when ever a serializer is created it will add a default
/// DateTime serializer which does not do all these things. We can override
/// the default DateTime serializer only if we add our serializer _AFTER_
/// the serializer is first created (which adds the default serializer in the
/// first place).
class ServerDateTimeSerializer extends PrimitiveSerializer<DateTime> {
  static var serverTimeSentinel = DateTime(0).toUtc();
  final bool structured = false;

  @override
  DateTime deserialize(Serializers serializers, Object serialized,
      {FullType specifiedType = FullType.unspecified}) {
    var microsecondsSinceEpoch = (serialized as double).floor();
    return DateTime.fromMicrosecondsSinceEpoch(
      microsecondsSinceEpoch,
      isUtc: true,
    );
  }

  @override
  Object serialize(Serializers serializers, DateTime object,
      {FullType specifiedType = FullType.unspecified}) {
    if (object == serverTimeSentinel) {
      return FirestoreDocConfig
          .instance.serverDateTimeConfig.serverTimestampFieldValue;
    }
    return FirestoreDocConfig.instance.serverDateTimeConfig
        .dateTimeConverter(object.toUtc());
  }

  @override
  Iterable<Type> get types => BuiltList<Type>([DateTime]);

  @override
  String get wireName => 'DateTime';
}

typedef DateTimeConverter = Object Function(DateTime timestampUtc);

class ServerDateTimeConfig {
  final dynamic
      serverTimestampFieldValue; // = Firestore.fieldValues.serverTimestamp();
  final DateTimeConverter dateTimeConverter;

  ServerDateTimeConfig({
    this.serverTimestampFieldValue,
    this.dateTimeConverter,
  });
}
