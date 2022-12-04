// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

DocumentReference firestoreDocRefFromJson(dynamic value) {
  if (value is DocumentReference) {
    return GetIt.instance.get<FirebaseFirestore>().doc(value.path);
  }

  return GetIt.instance.get<FirebaseFirestore>().doc(value);
}

dynamic firestoreDocRefToJson(DocumentReference value) => value;
