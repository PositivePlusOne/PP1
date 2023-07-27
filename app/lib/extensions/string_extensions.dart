// Project imports:
import 'dart:math';

import 'package:app/dtos/database/activities/tags.dart';
import 'package:app/dtos/localization/country.dart';

extension StringExt on String {
  static const int maxTagLength = 30;

  String buildPhoneNumber(Country country) {
    final StringBuffer phoneNumberBuffer = StringBuffer();

    if (!startsWith('+')) {
      phoneNumberBuffer.write('+${country.phoneCode}');
    }

    if (startsWith('0')) {
      phoneNumberBuffer.write(substring(1));
    } else {
      phoneNumberBuffer.write(this);
    }

    final String actualPhoneNumber = phoneNumberBuffer.toString();
    return actualPhoneNumber;
  }

  String get asTagKey {
    //* Validation of tags client side, please make sure this matches server side validation
    //* server side validation can be found in tags_service.ts under the function formatTag
    String string = this;
    string = string.replaceAll(RegExp('[^a-zA-Z0-9 ]+'), '');
    string = string.replaceAll(RegExp('\\s+'), '_');
    string = string.substring(0, min(string.length, maxTagLength));
    return string;
  }

  Tag get asTag {
    return Tag(
      localizations: [],
      fallback: asTagKey,
      key: asTagKey,
    );
  }
}

extension StringListExt on Iterable<String> {
  String get asGUID {
    final List<String> newMembers = {...this}.toList()..sort();
    return newMembers.join('-');
  }

  bool deepMatch(List<String> other) {
    if (length != other.length) {
      return false;
    }

    for (final String item in this) {
      if (!other.contains(item)) {
        return false;
      }
    }

    return true;
  }
}
