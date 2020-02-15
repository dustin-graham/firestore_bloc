import 'package:cloud_firestore/cloud_firestore.dart';
extension QueryExtensions on Query {
  Query whereTimestampIsNotNull(String timestampKey) {
    return this.where(
      timestampKey,
      isGreaterThan: Timestamp.fromDate(
        DateTime.fromMicrosecondsSinceEpoch(0),
      ),
    );
  }
}