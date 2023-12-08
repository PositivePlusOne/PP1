// Project imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/common/media.dart';

//? Simplified Activity structure
class ActivityData {
  ActivityData({
    this.activityID,
    this.reposterActivityID,
    this.content,
    this.altText,
    this.promotionKey,
    this.tags,
    this.allowSharing,
    this.visibilityMode,
    this.commentPermissionMode,
    this.postType,
    this.media,
    this.mentions = const [],
  });

  String? activityID;
  String? reposterActivityID;

  //UserIds mentioned in the post
  List<String> mentions;

  String? content;
  List<String>? tags;
  List<String>? taggedUsers;
  String? altText;
  String? promotionKey;

  bool? allowSharing;

  ActivitySecurityConfigurationMode? visibilityMode;
  ActivitySecurityConfigurationMode? commentPermissionMode;

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

  static PostType getPostTypeFromActivity(Activity activity, bool isEditing) {
    if (activity.generalConfiguration == null) {
      return PostType.error;
    }

    // All post types can be reposted, so we check for repost first
    if (activity.repostConfiguration?.targetActivityId.isNotEmpty == true && !isEditing) {
      return PostType.repost;
    }

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
  entry,
  camera,
  editPhoto,
  repostPreview,
  createPostText,
  createPostImage,
  createPostMultiImage,
  createPostClip,
  createPostEditClip;

  bool get isCreationDialog => this == CreatePostCurrentPage.createPostText || this == CreatePostCurrentPage.createPostImage || this == CreatePostCurrentPage.createPostMultiImage || this == CreatePostCurrentPage.createPostClip;
}
