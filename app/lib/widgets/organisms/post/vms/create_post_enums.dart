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
