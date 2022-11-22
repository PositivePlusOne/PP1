// Project imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ppoa/business/services/service_mixin.dart';

/// Provides customisation localizations for the PPOA application.
/// These can be modified through the CMS Flamelink.
///
/// Note: Only some documents in the app are localized, for example T&Cs.
class LocalizationService with ServiceMixin {
  /// The documents received from the database.
  final List<QueryDocumentSnapshot> localizationDocuments = <QueryDocumentSnapshot>[];

  /// If the database is available, will grab all up to date localizations for within the app.
  /// This should be called in the [SplashPage] before the application starts.
  Future<void> precacheLocalizations(Locale locale) async {
    log.finer('Attempting to load in-app localizations');
    if (!isRegistered<FirebaseFirestore>()) {
      log.severe('Failed to load localizations, database is not available');
      return;
    }

    Query<Map<String, dynamic>> collection = firestore.collection('fl_content');
    collection = collection.where('_fl_meta_.schema', isEqualTo: 'localizations');
    collection = collection.where('locale', isEqualTo: locale.languageCode);

    final QuerySnapshot<Map<String, dynamic>> results = await collection.get();
    for (final QueryDocumentSnapshot<Map<String, dynamic>> result in results.docs) {
      localizationDocuments.removeWhere((element) => element.id == result.id);
      localizationDocuments.add(result);
    }

    log.finer('Precached localizations successfully');
  }
}
