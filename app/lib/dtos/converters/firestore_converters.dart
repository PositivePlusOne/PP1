// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:app/main.dart';
import 'package:app/services/third_party.dart';

/// Deserialize Firebase DocumentReference data type from Firestore
DocumentReference? firestoreDocRefFromJson(dynamic value) {
  final FirebaseFirestore firebaseFirestore = providerContainer.read(firebaseFirestoreProvider);
  if (value is DocumentReference) {
    return firebaseFirestore.doc(value.path);
  } else if (value is String) {
    return firebaseFirestore.doc(value);
  }

  return null;
}

/// This method only stores the "relation" data type back in the Firestore
dynamic firestoreDocRefToJson(dynamic value) => value;
