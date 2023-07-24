// Project imports:
import 'package:app/dtos/localization/country.dart';

extension StringExt on String {
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
