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
