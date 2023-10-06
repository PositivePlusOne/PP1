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
import 'package:app/providers/content/dtos/gallery_entry.dart';
import 'package:app/providers/profiles/events/profile_switched_event.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/imagery/positive_media_image.dart';

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
    // this means that if you are logged and managing an organisation - you see the gallery of that org
    // and upload images for that org
    if (state.currentProfileId == null) {
      return '';
    }

    return '/users/${state.currentProfileId}';
    // if you didn't want to do the above and instead wanted to upload to your own folder, you could
    // choose to show your own gallery and upload to there too (as you are permitted to do so)
    /*
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
    return '/users/${profileController.currentUserId}';
    */
  }

  String get rootGalleryPath {
    return '$userFolderPath/gallery';
  }

  String referenceImagePath(String referenceImageName) {
    return '$userFolderPath/private/$referenceImageName';
  }

  String profileImagePath(String profileImageName) {
    return '$rootGalleryPath/$profileImageName';
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

  Future<GalleryEntry> createGalleryEntryFromXFile(XFile file, {bool uploadImmediately = true, bool store = true}) async {
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
    final Reference baseReference = store ? rootProfileGalleryReference : rootProfilePublicReference;
    final Reference child = baseReference.child(fileName);

    UploadTask? uploadTask;
    if (uploadImmediately) {
      uploadTask = child.putData(imageBytes, SettableMetadata(contentType: file.mimeType));
    }

    final Directory userStorageDirectory = await getUserStorageDirectory();
    final File localFile = File('${userStorageDirectory.path}/$fileName');
    await localFile.writeAsBytes(imageBytes);

    final GalleryEntry galleryEntry = GalleryEntry(
      reference: uploadImmediately ? child : null,
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

  /// helper to consistently return the filename prefix (to ID the image) from the type
  /// will be 'profile' or 'reference'
  String mediaTypePrefix(ProfileImageUpdateRequestType type) => type == ProfileImageUpdateRequestType.profile ? 'profile' : 'reference';

  /// helper to return the proper path to the file based on the type and the full filename (profile_id.jpeg for example)
  String _mediaTypePath(ProfileImageUpdateRequestType type, String filename) => type == ProfileImageUpdateRequestType.profile ? profileImagePath(filename) : referenceImagePath(filename);

  Future<Media> updateProfileOrReferenceImage(Uint8List data, ProfileImageUpdateRequestType type) async {
    final Logger logger = providerContainer.read(loggerProvider);
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
    final FirebaseStorage storage = providerContainer.read(firebaseStorageProvider);

    logger.i('[Gallery Controller] - Updating profile or reference image');
    if (profileController.currentProfileId == null) {
      throw Exception('No profile selected');
    }
    final profile = profileController.currentProfile;
    if (profile == null) {
      throw Exception('No profile resolved');
    }

    if (data.isEmpty) {
      throw Exception('No data provided');
    }
    // so we need to find the image path for the type of image requested - these images are 'named' with profile_ or reference_
    // so are pretty easy to find actually
    try {
      // find the current profile / reference image in order to delete it
      final currentMedia = profile.media.firstWhere((element) => element.name.startsWith(mediaTypePrefix(type)));
      // for which we need the actual path for this type
      final String path = _mediaTypePath(type, currentMedia.name);
      final String bucketPathWithoutFilename = path.substring(0, path.lastIndexOf('/'));
      final String filenameWithoutExtension = currentMedia.name.substring(0, currentMedia.name.lastIndexOf('.'));
      final String fileExtension = currentMedia.name.split('.').last;
      // for which we lso have thumbnails
      final Reference thumbnailPath = FirebaseStorage.instance.ref('$bucketPathWithoutFilename/thumbnails');
      for (final thumbnailSize in PositiveThumbnailTargetSize.values) {
        // File will with be filename + extension + suffix or filename + suffix + extension so ty to delete both / either
        final String filenameTypeOne = '$filenameWithoutExtension.${fileExtension}_${thumbnailSize.fileSuffix}';
        try {
          thumbnailPath.child(filenameTypeOne).delete();
        } catch (e) {
          logger.i('[Gallery Controller] - Deleting thumbnail at $filenameTypeOne did not do anything');
        }
        final String filenameTypeTwo = '${filenameWithoutExtension}_${thumbnailSize.fileSuffix}.$fileExtension';
        try {
          thumbnailPath.child(filenameTypeTwo).delete();
        } catch (e) {
          logger.i('[Gallery Controller] - Deleting thumbnail at $filenameTypeTwo did not do anything');
        }
      }

      // and deleting the actually profile image is important enough to wait for
      await storage.ref().child(path).delete();
    } catch (e) {
      logger.i('[Gallery Controller] - No existing image found');
    }

    // now, to place the new image into the store, we need to create new data, with a new filename so there are new thumbnails etc
    // as this file is under the users folder, and they can't fire off loads of these images in quick succession, we can just
    // use the current dateTime to ensure each uploaded image is unique
    final newFilename = '${mediaTypePrefix(type)}_${DateTime.now().toIso8601String()}.jpeg';
    final newFilepath = _mediaTypePath(type, newFilename);
    // which can be made into a file reference
    final Reference reference = storage.ref().child(newFilepath);
    // which we can put data in place for (uploading the image basically)
    await reference.putData(data, SettableMetadata(contentType: 'image/jpeg'));
    // now we have uploaded this media - let's return the object that represents it
    final Media media = Media(
      name: newFilename,
      bucketPath: newFilepath,
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
