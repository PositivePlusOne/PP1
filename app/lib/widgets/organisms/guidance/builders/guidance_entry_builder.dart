// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../dtos/database/guidance/guidance_directory_entry.dart';
import '../guidance_directory_entry.dart';
import 'builder.dart';

class GuidanceDirectoryEntryListBuilder implements ContentBuilder {
  final List<GuidanceDirectoryEntry> gdes;

  const GuidanceDirectoryEntryListBuilder(
    this.gdes,
  );

  @override
  Widget build() {
    return GuidanceDirectoryEntryList(gdes);
  }
}

class GuidanceDirectoryEntryContentBuilder implements ContentBuilder {
  final GuidanceDirectoryEntry ga;

  const GuidanceDirectoryEntryContentBuilder(this.ga);

  @override
  Widget build() => GuidanceDirectoryEntryContent(ga);
}
