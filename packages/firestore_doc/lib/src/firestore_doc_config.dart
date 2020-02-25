import 'package:meta/meta.dart';

import 'serialization/server_date_time_serializer.dart';

class FirestoreDocConfig {
  FirestoreDocConfig._();

  static FirestoreDocConfig instance = FirestoreDocConfig._();

  ServerDateTimeConfig _serverDateTimeConfig;

  ServerDateTimeConfig get serverDateTimeConfig => _serverDateTimeConfig;

  void configure({@required ServerDateTimeConfig serverDateTimeConfig}) {
    _serverDateTimeConfig = serverDateTimeConfig;
  }
}
