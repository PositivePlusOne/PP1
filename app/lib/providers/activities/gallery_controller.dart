// Dart imports:
import 'dart:async';
import 'dart:typed_data';

// Package imports:
import 'package:event_bus/event_bus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/common/media.dart';
import 'package:app/main.dart';
import 'package:app/providers/activities/dtos/gallery_entry.dart';
import 'package:app/providers/profiles/events/profile_switched_event.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/services/third_party.dart';

part 'gallery_controller.freezed.dart';
part 'gallery_controller.g.dart';

@freezed
class GalleryControllerState with _$GalleryControllerState {
  const factory GalleryControllerState({
    @Default([]) List<GalleryEntry> galleryEntries,
    DateTime? galleryLastUpdated,
  }) = _GalleryControllerState;

  factory GalleryControllerState.initialState() => const GalleryControllerState();
}

enum ProfileImageUpdateRequestType { profile, reference }

@Riverpod(keepAlive: true)
class GalleryController extends _$GalleryController {
  StreamSubscription<ProfileSwitchedEvent>? _profileSwitchedSubscription;

  @override
  GalleryControllerState build() {
    return GalleryControllerState.initialState();
  }

  String get userFolderPath {
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
    if (profileController.currentProfileId == null) {
      return '';
    }

    return 'users/${profileController.currentProfileId}';
  }

  String get rootGalleryPath {
    return '$userFolderPath/gallery';
  }

  String get referenceImagePath {
    return '$rootGalleryPath/referenceImages/main.jpg';
  }

  String get profileImagePath {
    return '$rootGalleryPath/profileImages/main.jpg';
  }

  Reference get rootProfileGalleryReference {
    return FirebaseStorage.instance.ref().child(rootGalleryPath);
  }

  List<Media> get galleryMediaEntries {
    final List<Media> mediaEntries = <Media>[];
    for (final GalleryEntry galleryEntry in state.galleryEntries) {
      mediaEntries.add(buildMediaEntryFromGalleryEntry(galleryEntry));
    }

    return mediaEntries;
  }

  Future<void> setupListeners() async {
    final Logger logger = providerContainer.read(loggerProvider);
    final EventBus eventBus = providerContainer.read(eventBusProvider);

    logger.i('[Gallery Controller] - Setting up listeners');
    await _profileSwitchedSubscription?.cancel();
    _profileSwitchedSubscription = eventBus.on<ProfileSwitchedEvent>().listen(onUserProfileSwitched);
  }

  void onUserProfileSwitched(ProfileSwitchedEvent event) {
    final Logger logger = providerContainer.read(loggerProvider);

    logger.i('[Gallery Controller] - Profile switched: ${event.profileId}');
    if (event.profileId.isEmpty) {
      state = GalleryControllerState.initialState();
      return;
    }

    syncGallery();
  }

  Future<void> syncGallery() async {
    final Logger logger = providerContainer.read(loggerProvider);
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);

    logger.i('[Gallery Controller] - Syncing gallery');
    if (profileController.currentProfileId == null) {
      logger.i('[Gallery Controller] - No profile selected');
      return;
    }

    final List<GalleryEntry> galleryEntries = await getGalleryEntries();
    state = state.copyWith(galleryEntries: galleryEntries, galleryLastUpdated: DateTime.now());
  }

  void notifyGalleryUpdated() {
    state = state.copyWith(galleryLastUpdated: DateTime.now());
  }

  Future<List<GalleryEntry>> getGalleryEntries() async {
    final Logger logger = providerContainer.read(loggerProvider);
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);

    logger.i('[Gallery Controller] - Getting gallery entries');
    if (profileController.currentProfileId == null) {
      logger.i('[Gallery Controller] - No profile selected');
      return [];
    }

    final ListResult result = await rootProfileGalleryReference.listAll();
    final List<GalleryEntry> galleryEntries = await Future.wait(result.items.map((Reference reference) async {
      final String? mimeType = await reference.getMetadata().then((FullMetadata value) => value.contentType);
      return GalleryEntry(reference: reference, mimeType: mimeType);
    }));

    logger.i('[Gallery Controller] - Got ${galleryEntries.length} gallery entries');

    return galleryEntries;
  }

  Future<GalleryEntry> createGalleryEntryFromXFile(XFile file) async {
    final Logger logger = providerContainer.read(loggerProvider);
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);

    logger.i('[Gallery Controller] - Creating reference from XFile');
    if (profileController.currentProfileId == null) {
      logger.i('[Gallery Controller] - No profile selected');
      throw Exception('No profile selected');
    }

    final String fileName = file.path.split('/').last;
    final Uint8List bytes = await file.readAsBytes();
    final Reference child = rootProfileGalleryReference.child(fileName);

    await child.updateMetadata(SettableMetadata(contentType: file.mimeType));

    final UploadTask uploadTask = child.putData(bytes);
    final GalleryEntry galleryEntry = GalleryEntry(
      reference: child,
      data: bytes,
      storageUploadTask: uploadTask,
    );

    registerEventListenersForUpload(galleryEntry);

    logger.i('[Gallery Controller] - Created reference from XFile');
    state = state.copyWith(galleryEntries: [...state.galleryEntries, galleryEntry]);

    return galleryEntry;
  }

  void registerEventListenersForUpload(GalleryEntry entry) {
    final Logger logger = providerContainer.read(loggerProvider);
    logger.i('[Gallery Controller] - Registering event listeners for upload');

    entry.storageUploadTask?.snapshotEvents.listen((TaskSnapshot snapshot) {
      logger.i('[Gallery Controller] - Upload event: ${snapshot.state}');
      notifyGalleryUpdated();
    });
  }

  void registerEventListenersForDownload(GalleryEntry entry) {
    final Logger logger = providerContainer.read(loggerProvider);
    logger.i('[Gallery Controller] - Registering event listeners for download');

    entry.storageDownloadTask?.snapshotEvents.listen((TaskSnapshot snapshot) {
      logger.i('[Gallery Controller] - Download event: ${snapshot.state}');
      notifyGalleryUpdated();
    });
  }

  Future<void> requestGalleryEntryDataFetch(GalleryEntry entry) async {
    final Logger logger = providerContainer.read(loggerProvider);
    logger.i('[Gallery Controller] - Requesting gallery entry data fetch');

    if (entry.data != null) {
      logger.i('[Gallery Controller] - Gallery entry data already fetched');
      return;
    }

    // TODO(ryan): Check for thumnails if needbe

    final Uint8List? bytes = await entry.reference.getData();
    final String? mimeType = await entry.reference.getMetadata().then((FullMetadata value) => value.contentType);
    logger.i('[Gallery Controller] - Got ${bytes?.length} bytes - $mimeType');

    final GalleryEntry updatedEntry = GalleryEntry(
      reference: entry.reference,
      data: bytes,
      mimeType: mimeType,
      storageUploadTask: entry.storageUploadTask,
      storageDownloadTask: entry.storageDownloadTask,
    );

    state = state.copyWith(
        galleryEntries: state.galleryEntries.map((GalleryEntry e) {
      if (e.reference.fullPath == updatedEntry.reference.fullPath) {
        return updatedEntry;
      }

      return e;
    }).toList());
  }

  Future<void> deleteGalleryEntry(GalleryEntry entry) async {
    final Logger logger = providerContainer.read(loggerProvider);
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);

    logger.i('[Gallery Controller] - Deleting gallery entry');
    if (profileController.currentProfileId == null) {
      logger.i('[Gallery Controller] - No profile selected');
      throw Exception('No profile selected');
    }

    await entry.reference.delete();
    state = state.copyWith(galleryEntries: state.galleryEntries.where((GalleryEntry e) => e != entry).toList());
  }

  Future<Media> updateProfileOrReferenceImage(Uint8List data, ProfileImageUpdateRequestType type) async {
    final Logger logger = providerContainer.read(loggerProvider);
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);

    logger.i('[Gallery Controller] - Updating profile or reference image');
    if (profileController.currentProfileId == null) {
      throw Exception('No profile selected');
    }

    final String path = type == ProfileImageUpdateRequestType.profile ? profileImagePath : referenceImagePath;
    final Reference reference = FirebaseStorage.instance.ref().child(path);

    try {
      await reference.delete();
    } catch (e) {
      logger.i('[Gallery Controller] - No existing image found');
    }

    await reference.updateMetadata(SettableMetadata(contentType: 'image/jpeg'));
    await reference.putData(data);

    final Media media = Media(url: path, priority: kMediaPriorityDefault, type: MediaType.bucket_path);
    return media;
  }

  Media buildMediaEntryFromGalleryEntry(GalleryEntry entry) {
    final String relativePath = entry.reference.fullPath.replaceFirst(rootProfileGalleryReference.fullPath, '');
    return Media(url: relativePath, priority: kMediaPriorityDefault, type: MediaType.bucket_path);
  }
}
