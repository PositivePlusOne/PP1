// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:app/dtos/database/common/fl_meta.dart';

class FlamelinkHelpers {
  static Timestamp? getCreatedDateFromMap(Map<String, dynamic> map) {
    if (map['_fl_meta_'] != null && map['_fl_meta_']['createdDate'] != null && map['_fl_meta_']['createdDate'] is Timestamp) {
      return map['_fl_meta_']['createdDate'];
    }

    return null;
  }

  static Timestamp? getUpdatedDateFromMap(Map<String, dynamic> map) {
    if (map['_fl_meta_'] != null && map['_fl_meta_']['lastModifiedDate'] != null && map['_fl_meta_']['lastModifiedDate'] is Timestamp) {
      return map['_fl_meta_']['lastModifiedDate'];
    }

    return null;
  }

  static bool hasUpdatedDocumentFromFlMeta(FlMeta flMeta) {
    if (flMeta.createdDate != null && flMeta.lastModifiedDate != null) {
      return flMeta.createdDate != flMeta.lastModifiedDate;
    }

    return false;
  }

  static bool hasUpdatedDocumentFromMap(Map<String, dynamic> map) {
    final createdDate = getCreatedDateFromMap(map);
    final updatedDate = getUpdatedDateFromMap(map);

    if (createdDate != null && updatedDate != null) {
      return createdDate != updatedDate;
    }

    return false;
  }
}
