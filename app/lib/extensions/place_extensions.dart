// Package imports:
import 'package:logger/logger.dart';

// Project imports:
import 'package:app/dtos/database/geo/positive_restricted_place.dart';
import 'package:app/main.dart';
import 'package:app/services/third_party.dart';

extension PositiveRestrictedPlaceExtensions on PositiveRestrictedPlace {
  bool get isNonNumericOperation {
    return enforcementMatcher.when(
      equal: () => true,
      notEqual: () => true,
      lessThan: () => false,
      lessThanOrEqual: () => false,
      greaterThan: () => false,
      greaterThanOrEqual: () => false,
      unknown: () => false,
    );
  }

  bool get isEqualMatcher {
    return enforcementMatcher.when(
      equal: () => true,
      notEqual: () => false,
      lessThan: () => false,
      lessThanOrEqual: () => false,
      greaterThan: () => false,
      greaterThanOrEqual: () => false,
      unknown: () => false,
    );
  }

  bool get isNotEqualMatcher {
    return enforcementMatcher.when(
      equal: () => false,
      notEqual: () => true,
      lessThan: () => false,
      lessThanOrEqual: () => false,
      greaterThan: () => false,
      greaterThanOrEqual: () => false,
      unknown: () => false,
    );
  }

  Future<bool> performCheck({
    required Map<String, dynamic> addressComponents,
  }) async {
    final Logger logger = providerContainer.read(loggerProvider);
    final bool supportsExpectedValue = await ruleSupportsExpectedValue();
    if (!supportsExpectedValue) {
      logger.d('Rule does not support expected value');
      return false;
    }

    if (addressComponents.isEmpty) {
      logger.d('No params provided');
      return false;
    }

    return enforcementType.when(
      administrativeAreaLevelOne: () => performAreaCheck(
        type: enforcementType,
        value: addressComponents.containsKey('administrative_area_level_1') ? addressComponents['administrative_area_level_1'] : null,
      ),
      administrativeAreaLevelTwo: () => performAreaCheck(
        type: enforcementType,
        value: addressComponents.containsKey('administrative_area_level_2') ? addressComponents['administrative_area_level_2'] : null,
      ),
      country: () => performAreaCheck(
        type: enforcementType,
        value: addressComponents.containsKey('country') ? addressComponents['country'] : null,
      ),
      locality: () => performAreaCheck(
        type: enforcementType,
        value: addressComponents.containsKey('locality') ? addressComponents['locality'] : null,
      ),
      distance: () => throw UnimplementedError(),
      unknown: () => false,
    );
  }

  Future<bool> performAreaCheck({
    required PositiveRestrictedPlaceEnforcementType type,
    required dynamic value,
  }) async {
    final Logger logger = providerContainer.read(loggerProvider);
    final bool supportsExpectedValue = await ruleSupportsExpectedValue();
    if (!supportsExpectedValue) {
      logger.d('Rule does not support expected value');
      return false;
    }

    if (value == null) {
      logger.d('No value provided');
      return false;
    }

    final bool isNumeric = double.tryParse(enforcementValue) != null;
    if (isNumeric) {
      logger.d('Value is numeric');
      return false;
    }

    final bool isEqual = isEqualMatcher;
    final bool isNotEqual = isNotEqualMatcher;

    String actualValue = '';
    if (value is Iterable) {
      actualValue = (value.firstOrNull ?? '').toString().toLowerCase().trim();
    } else {
      actualValue = value.toString().toLowerCase().trim();
    }

    final String enforcementValueString = enforcementValue.toLowerCase().trim();

    if (isEqual) {
      logger.d('Checking equality');
      return actualValue == enforcementValueString;
    }

    if (isNotEqual) {
      logger.d('Checking inequality');
      return actualValue != enforcementValueString;
    }

    logger.d('Unknown matcher');
    return false;
  }

  Future<bool> ruleSupportsExpectedValue() async {
    if (enforcementValue.isEmpty) {
      return false;
    }

    final bool isNumeric = double.tryParse(enforcementValue) != null;
    return enforcementMatcher.when(
      equal: () => true,
      notEqual: () => true,
      lessThan: () => isNumeric,
      lessThanOrEqual: () => isNumeric,
      greaterThan: () => isNumeric,
      greaterThanOrEqual: () => isNumeric,
      unknown: () => false,
    );
  }
}
