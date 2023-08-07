// ignore_for_file: avoid_public_notifier_properties

// Dart imports:
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

// Package imports:
import 'package:event_bus/event_bus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
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
    String? currentProfileId,
    DateTime? galleryLastUpdated,
    @Default([]) List<GalleryEntry> galleryEntries,
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

  Future<Directory> getUserStorageDirectory() async {
    final Directory folder = await getApplicationDocumentsDirectory();
    final Directory directory = Directory('${folder.path}$userFolderPath');
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    return directory;
  }

  String get userFolderPath {
    if (state.currentProfileId == null) {
      return '';
    }

    return '/users/${state.currentProfileId}';
  }

  String get rootGalleryPath {
    return '$userFolderPath/gallery';
  }

  String get referenceImagePath {
    return '$userFolderPath/private/reference.jpeg';
  }

  String get profileImagePath {
    return '$rootGalleryPath/profile.jpeg';
  }

  Reference get rootProfileGalleryReference {
    return FirebaseStorage.instance.ref().child(rootGalleryPath);
  }

  Reference get rootProfilePrivateReference {
    return FirebaseStorage.instance.ref().child('$userFolderPath/private');
  }

  Reference get rootProfilePublicReference {
    return FirebaseStorage.instance.ref().child('$userFolderPath/public');
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
    if (event.profileId == state.currentProfileId) {
      logger.i('[Gallery Controller] - Profile already switched: ${event.profileId}');
      return;
    }

    logger.i('[Gallery Controller] - Profile switched: ${event.profileId}');
    if (event.profileId.isEmpty) {
      state = GalleryControllerState.initialState();
      return;
    }

    state = state.copyWith(currentProfileId: event.profileId);
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
    final List<GalleryEntry> remoteGalleryEntries = await Future.wait(result.items.map((Reference reference) async {
      final String? mimeType = await reference.getMetadata().then((FullMetadata value) => value.contentType);
      return GalleryEntry(reference: reference, mimeType: mimeType);
    }));

    final Directory userStorageDirectory = await getUserStorageDirectory();
    final List<GalleryEntry> localGalleryEntries = <GalleryEntry>[];
    final List<FileSystemEntity> localGalleryFiles = userStorageDirectory.listSync(recursive: true);

    for (final FileSystemEntity fileSystemEntity in localGalleryFiles) {
      if (fileSystemEntity is! File) {
        continue;
      }

      final File file = fileSystemEntity;
      final String? mimeType = lookupMimeType(file.path);
      final GalleryEntry galleryEntry = GalleryEntry(
        file: XFile(file.path),
        mimeType: mimeType,
      );

      localGalleryEntries.add(galleryEntry);
    }

    final List<GalleryEntry> galleryEntries = <GalleryEntry>[
      ...remoteGalleryEntries,
      ...localGalleryEntries,
    ];

    // Remove duplicate file names
    final Map<String, GalleryEntry> galleryEntriesMap = <String, GalleryEntry>{};
    for (final GalleryEntry galleryEntry in galleryEntries) {
      galleryEntriesMap[galleryEntry.fileName] = galleryEntry;
    }

    logger.i('[Gallery Controller] - Got ${galleryEntriesMap.length} gallery entries');

    return galleryEntriesMap.values.toList();
  }

  Future<GalleryEntry> createGalleryEntryFromXFile(XFile file, {bool uploadImmediately = true}) async {
    final Logger logger = providerContainer.read(loggerProvider);
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);

    logger.i('[Gallery Controller] - Creating reference from XFile');
    if (profileController.currentProfileId == null) {
      logger.i('[Gallery Controller] - No profile selected');
      throw Exception('No profile selected');
    }

    final Uint8List imageBytes = await file.readAsBytes();
    final String mimeType = lookupMimeType(file.path, headerBytes: imageBytes) ?? 'application/octet-stream';
    final String mimeExtension = extensionFromMime(mimeType);

    // Filename is the date with a random amount of time added to it
    final num date = DateTime.now().millisecondsSinceEpoch;
    final String randomTime = ref.read(randomProvider).nextInt(100000).toString();
    final String fileName = '${date}_$randomTime.$mimeExtension';
    final Reference child = rootProfileGalleryReference.child(fileName);

    UploadTask? uploadTask;
    if (uploadImmediately) {
      uploadTask = child.putData(imageBytes, SettableMetadata(contentType: file.mimeType));
    }

    final Directory userStorageDirectory = await getUserStorageDirectory();
    final File localFile = File('${userStorageDirectory.path}/$fileName');
    await localFile.writeAsBytes(imageBytes);

    final GalleryEntry galleryEntry = GalleryEntry(
      reference: child,
      mimeType: mimeType,
      file: XFile(localFile.path),
      data: imageBytes,
      storageUploadTask: uploadTask,
    );

    if (uploadImmediately) {
      registerEventListenersForUpload(galleryEntry);
    }

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

    final Uint8List? bytes = await entry.reference?.getData();
    final String? mimeType = await entry.reference?.getMetadata().then((FullMetadata value) => value.contentType);
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
      if (e.reference?.fullPath == updatedEntry.reference?.fullPath) {
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

    await entry.reference?.delete();
    state = state.copyWith(galleryEntries: state.galleryEntries.where((GalleryEntry e) => e != entry).toList());
  }

  Future<Media> updateProfileOrReferenceImage(Uint8List data, ProfileImageUpdateRequestType type) async {
    final Logger logger = providerContainer.read(loggerProvider);
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
    final FirebaseStorage storage = providerContainer.read(firebaseStorageProvider);

    logger.i('[Gallery Controller] - Updating profile or reference image');
    if (profileController.currentProfileId == null) {
      throw Exception('No profile selected');
    }

    if (data.isEmpty) {
      throw Exception('No data provided');
    }

    final String path = type == ProfileImageUpdateRequestType.profile ? profileImagePath : referenceImagePath;
    final Reference reference = storage.ref().child(path);

    try {
      await reference.delete();
    } catch (e) {
      logger.i('[Gallery Controller] - No existing image found');
    }

    await reference.putData(data, SettableMetadata(contentType: 'image/jpeg'));

    final Media media = Media(
      name: type == ProfileImageUpdateRequestType.profile ? 'profile.jpeg' : 'reference.jpeg',
      bucketPath: path,
      priority: kMediaPriorityDefault,
      type: MediaType.bucket_path,
      isPrivate: type == ProfileImageUpdateRequestType.reference,
    );

    return media;
  }

  Media buildMediaEntryFromGalleryEntry(GalleryEntry entry, {bool isSensitive = false, bool isPrivate = false}) {
    if (entry.reference == null) {
      throw Exception('No reference found');
    }

    final String relativePath = entry.reference!.fullPath.replaceFirst(rootProfileGalleryReference.fullPath, '');
    return Media(url: relativePath, priority: kMediaPriorityDefault, type: MediaType.bucket_path, isPrivate: isPrivate, isSensitive: isSensitive);
  }
}
