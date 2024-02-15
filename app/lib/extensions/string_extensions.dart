// Dart imports:
import 'dart:math';

// Package imports:
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:app/constants/country_constants.dart';
import 'package:app/dtos/database/activities/tags.dart';
import 'package:app/dtos/localization/country.dart';
import 'package:app/extensions/profile_extensions.dart';

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

  (String countryCode, String phoneNumber) formatPhoneNumberIntoComponents() {
    if (!startsWith("+")) {
      return ('', this);
    }

    // Use kCountryList to find the country code
    String countryCode = '';
    for (final Country country in kCountryList) {
      if (startsWith("+${country.phoneCode}")) {
        countryCode = country.phoneCode;
        break;
      }
    }

    if (countryCode.isEmpty) {
      return ('', this);
    }

    // Replace the country code with a placeholder 0
    final String phoneNumberWithReplacement = replaceFirst("+$countryCode", "0");
    return (countryCode, phoneNumberWithReplacement);
  }

  Future<void> attemptToLaunchURL() async {
    final Uri? uri = Uri.tryParse(this);
    if (uri != null) {
      await launchUrl(uri);
    }
  }

  bool get isSvgUrl {
    if (!startsWith("http://") && !startsWith("https://")) {
      return false;
    }

    return contains(".svg");
  }

  String get asTagKey {
    //* Validation of tags client side, please make sure this matches server side validation
    //* server side validation can be found in tags_service.ts under the function formatTag
    String string = this;
    string = string.replaceAll(RegExp('[^a-zA-Z0-9 ]+'), '');
    string = string.replaceAll(RegExp('\\s+'), '_');
    string = string.substring(0, min(string.length, maxTagLength));
    string = string.toLowerCase();
    return string;
  }

  Tag get asTag {
    final String tagKey = asTagKey;
    return Tag(
      localizations: [],
      fallback: tagKey,
      key: tagKey,
    );
  }

  String removeHandles() {
    return startsWith('@') ? substring(1, length) : this;
  }

  Iterable<String> getHandles({bool includeHandle = true}) {
    final RegExp exp = RegExp(r"@\w+[\w\-]*");
    return exp.allMatches(this).map((match) => substring(match.start + (includeHandle ? 0 : 1), match.end));
  }

  Iterable<String> getTags({bool includeHandle = true}) {
    final RegExp exp = RegExp(r"#\w+[\w\-]*");
    return exp.allMatches(this).map((match) => substring(match.start + (includeHandle ? 0 : 1), match.end));
  }

  String boldHandles() {
    final RegExp exp = RegExp(r"@\w+[\w\-]*");
    return replaceAllMapped(exp, (match) => '**${match.group(0)}**');
  }

  String boldHandlesAndLink({Map<String, String> knownIdMap = const {}}) {
    final RegExp exp = RegExp(r"@\w+[\w\-]*");
    return replaceAllMapped(exp, (match) {
      if (!knownIdMap.containsKey(match.group(0))) {
        return '**${match.group(0)}**';
      }

      return '[**${match.group(0)}**](${match.group(0)?.buildProfileStringLink(knownIdMap: knownIdMap)})';
    });
  }

  String squashParagraphs() {
    return replaceAll(RegExp(r'\n+'), ' ');
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
