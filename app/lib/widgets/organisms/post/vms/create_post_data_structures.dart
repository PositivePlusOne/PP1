// Project imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/common/media.dart';

//? Simplified Activity structure
class ActivityData {
  ActivityData({
    this.activityID,
    this.content,
    this.altText,
    this.tags,
    this.allowComments,
    this.allowSharing,
    this.visibleTo,
    this.postType,
    this.media,
  });

  String? activityID;

  String? content;
  String? altText;
  String? allowComments;
  bool? allowSharing;
  List<String>? tags;
  String? visibleTo;
  PostType? postType;
  List<Media>? media;
}

enum PostType {
  text,
  image,
  multiImage,
  clip,
  event,
  repost,
  error;

  static PostType getPostTypeFromActivity(Activity activity) {
    if (activity.generalConfiguration == null) return PostType.error;
    return activity.generalConfiguration!.type.when<PostType>(
      post: () {
        switch (activity.media.length) {
          case 0:
            return PostType.text;
          case 1:
            return PostType.image;
          default:
            return PostType.multiImage;
        }
      },
      event: () => PostType.clip,
      clip: () => PostType.event,
      repost: () => PostType.repost,
      bookmark: () => PostType.error,
    );
  }
}

enum PostUserShareType {
  everyone,
  connections,
  followers,
  myself,
}

enum PositivePostNavigationButtonStyle {
  filled,
  disabled,
  hollow,
}

enum PositivePostNavigationActiveButton {
  post,
  clip,
  event,
  flex,
}

enum CreatePostCurrentPage {
  camera,
  galleryPreview,
  editPhoto,
  createPostText,
  createPostImage,
  createPostMultiImage;

  bool get isCreationDialog => this == CreatePostCurrentPage.createPostText || this == CreatePostCurrentPage.createPostImage || this == CreatePostCurrentPage.createPostMultiImage;
}
