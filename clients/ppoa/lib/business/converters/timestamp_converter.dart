// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

/// Deserialize Firebase Timestamp data type from Firestore
Timestamp firestoreTimestampFromJson(dynamic value) {
  return value != null ? Timestamp.fromMicrosecondsSinceEpoch(value) : value;
}

/// This method only stores the "timestamp" data type back in the Firestore
dynamic firestoreTimestampToJson(Timestamp value) => value;
