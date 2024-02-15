class MarkdownTruncator {
  static const String asteriskItalic = '*';
  static const String underscoreItalic = '_';
  static const String asteriskBold = '**';
  static const String underscoreBold = '__';
  static const String escapedUnderscore = '\\_';
  static const String escapedAsterisk = '\\*';

  static final RegExp escapedAsteriskRegexp = RegExp(r'\\\*');
  static final RegExp asteriskPlaceholderRegexp = RegExp(r'ASTERISKPLACEHOLDER');

  static final RegExp escapedUnderscoreRegexp = RegExp(r'\\_');
  static final RegExp underscorePlaceholderRegexp = RegExp(r'UNDERSCOREPLACEHOLDER');

  static final RegExp underscoreBoldPlaceholderRegexp = RegExp(r'UNDERSCOREBOLDPLACEHOLDER');
  static final RegExp underscoreBoldRegexp = RegExp(r'(__)(.*?)(__)', dotAll: true);

  static final RegExp asteriskBoldPlaceholderRegexp = RegExp(r'ASTERISKBOLDPLACEHOLDER');
  static final RegExp asteriskBoldRegexp = RegExp(r'(\*\*)(.*?)(\*\*)', dotAll: true);

  static final RegExp underscoreItalicPlaceholderRegexp = RegExp(r'UNDERSCOREITALICPLACEHOLDER');
  static final RegExp underscoreItalicRegexp = RegExp(r'(_)(.*?)(_)', dotAll: true);

  static final RegExp asteriskItalicPlaceholderRegexp = RegExp(r'ASTERISKITALICPLACEHOLDER');
  static final RegExp asteriskItalicRegexp = RegExp(r'(\*)(.*?)(\*)', dotAll: true);

  static final RegExp hyperlink = RegExp(r'^\[([^[]+)\]\(([^)]+)\)');

  static String replaceFormatMarkersWithPlaceholders(String text) {
    return text
        .replaceAll(escapedUnderscoreRegexp, underscorePlaceholderRegexp.pattern)
        .replaceAll(escapedAsteriskRegexp, asteriskPlaceholderRegexp.pattern)
        .replaceAllMapped(underscoreBoldRegexp, (match) => '${underscoreBoldPlaceholderRegexp.pattern}${match.group(2)}${underscoreBoldPlaceholderRegexp.pattern}')
        .replaceAllMapped(asteriskBoldRegexp, (match) => '${asteriskBoldPlaceholderRegexp.pattern}${match.group(2)}${asteriskBoldPlaceholderRegexp.pattern}')
        .replaceAllMapped(underscoreItalicRegexp, (match) => '${underscoreItalicPlaceholderRegexp.pattern}${match.group(2)}${underscoreItalicPlaceholderRegexp.pattern}')
        .replaceAllMapped(asteriskItalicRegexp, (match) => '${asteriskItalicPlaceholderRegexp.pattern}${match.group(2)}${asteriskItalicPlaceholderRegexp.pattern}');
  }

  static String replaceFormatPlaceholdersWithMarkers(String text) {
    return text.replaceAll(underscorePlaceholderRegexp, escapedUnderscore).replaceAll(asteriskPlaceholderRegexp, escapedAsterisk).replaceAll(underscoreBoldPlaceholderRegexp, underscoreBold).replaceAll(asteriskBoldPlaceholderRegexp, asteriskBold).replaceAll(underscoreItalicPlaceholderRegexp, underscoreItalic).replaceAll(asteriskItalicPlaceholderRegexp, asteriskItalic);
  }

  static Map<String, int> get formatPlaceholdersMap => {
        underscorePlaceholderRegexp.pattern: escapedUnderscore.length,
        asteriskPlaceholderRegexp.pattern: escapedAsterisk.length,
      };

  static String? findFormatPlaceholderAhead(String text) {
    for (var formatPlaceholder in formatPlaceholdersMap.keys) {
      if (text.startsWith(formatPlaceholder)) {
        return formatPlaceholder;
      }
    }
    return null;
  }

  static List<String> get formatMarkers => [
        asteriskBoldPlaceholderRegexp.pattern,
        underscoreBoldPlaceholderRegexp.pattern,
        asteriskItalicPlaceholderRegexp.pattern,
        underscoreItalicPlaceholderRegexp.pattern,
      ];

  static String? findFormatMarkerAhead(String text, List<String> formatStack) {
    for (var formatMarker in formatMarkers) {
      if (text.startsWith(formatMarker)) {
        if (formatStack.isNotEmpty && formatStack.last == formatMarker) {
          formatStack.removeLast();
        } else {
          formatStack.add(formatMarker);
        }
        return formatMarker;
      }
    }
    return null;
  }

  static String truncate(String text, int limit, bool ellipsis) {
    int count = 0;
    String truncateString(String text) {
      List<String> formatStack = [];
      bool skipCountIncrement = false;
      String outputText = '';
      int index = 0;

      while (count < limit && index < text.length) {
        final formatMarker = findFormatMarkerAhead(text.substring(index), formatStack);
        if (formatMarker != null) {
          outputText += formatMarker;
          index += formatMarker.length;
          skipCountIncrement = true;
        }

        final formatPlaceholder = findFormatPlaceholderAhead(text.substring(index));
        if (formatPlaceholder != null) {
          outputText += formatPlaceholder;
          index += formatPlaceholder.length;
          skipCountIncrement = true;
          count += formatPlaceholdersMap[formatPlaceholder]!;
        }

        final hyperlinkMatch = hyperlink.firstMatch(text.substring(index));
        if (hyperlinkMatch != null) {
          final hyperlinkText = hyperlinkMatch.group(1)!;
          final hyperlinkUrl = hyperlinkMatch.group(2)!;

          outputText += '[$hyperlinkText]($hyperlinkUrl)';
          index += hyperlinkMatch.group(0)!.length;
          skipCountIncrement = true;
        }

        if (formatMarker == null && hyperlinkMatch == null) {
          outputText += text[index];
          index++;
        }

        if (!skipCountIncrement) {
          count++;
        }

        skipCountIncrement = false;
      }

      outputText = outputText.trimRight();

      while (formatStack.isNotEmpty) {
        outputText += formatStack.removeLast();
      }

      return outputText;
    }

    String outputText = truncateString(text);

    if (ellipsis && outputText.length < text.length) {
      outputText += '...';
    }

    return outputText;
  }

  static String formatText(String text, {int? limit, bool ellipsis = false}) {
    if (limit == null || text.length <= limit) {
      return text;
    }

    String outputText = replaceFormatMarkersWithPlaceholders(text);
    outputText = truncate(outputText, limit, ellipsis);
    outputText = replaceFormatPlaceholdersWithMarkers(outputText);

    return outputText;
  }
}
