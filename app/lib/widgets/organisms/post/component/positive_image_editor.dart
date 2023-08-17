import 'package:app/providers/activities/dtos/gallery_entry.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PositiveImageEditor extends ConsumerWidget {
  const PositiveImageEditor({super.key, this.galleryEntry});

  final GalleryEntry? galleryEntry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(color: Colors.brown);
  }
}
