// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:app/providers/guidance/guidance_controller.dart';
import '../../../../dtos/database/guidance/guidance_directory_entry.dart';
import '../guidance_directory_entry.dart';
import 'builder.dart';

class GuidanceDirectoryEntryListBuilder implements ContentBuilder {
  const GuidanceDirectoryEntryListBuilder({
    required this.directoryEntries,
    required this.controller,
  });

  final List<GuidanceDirectoryEntry> directoryEntries;
  final GuidanceController controller;

  @override
  Widget build() {
    return GuidanceDirectoryEntryList(
      directoryEntries: directoryEntries,
      controller: controller,
    );
  }
}

class GuidanceDirectoryEntryContentBuilder implements ContentBuilder {
  final GuidanceDirectoryEntry directoryEntries;

  const GuidanceDirectoryEntryContentBuilder(this.directoryEntries);

  @override
  Widget build() => GuidanceDirectoryEntryContent(directoryEntries);
}
