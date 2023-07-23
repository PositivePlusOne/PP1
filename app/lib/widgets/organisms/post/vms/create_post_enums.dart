import 'package:app/dtos/database/activities/activities.dart';

enum CreatePostCurrentPage {
  camera,
  createPostText,
  createPostImage,
  createPostMultiImage,
}

enum PostType {
  text,
  image,
  multiImage,
  clip,
  event,
  repost,
  error;

  static PostType getPostTypeFromString(ActivityGeneralConfigurationType typeString, int? imageCount) {
    return typeString.when<PostType>(
      post: () {
        switch (imageCount) {
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
